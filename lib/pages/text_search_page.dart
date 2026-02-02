import "dart:async";
import "dart:convert";

import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:provider/provider.dart";

import "../config/api_config.dart";
import "../l10n/app_localizations.dart";
import "../models/scan_result.dart";
import "../models/similar_item.dart";
import "../models/warning.dart";
import "../services/mock_similarity_service.dart";
import "../state/app_state.dart";
import "../theme/design_tokens.dart";
import "../widgets/section_title.dart";
import "../widgets/similar_item_card.dart";
import "city_picker_page.dart";
import "result_page.dart";

class TextSearchPage extends StatefulWidget {
  const TextSearchPage({super.key});

  @override
  State<TextSearchPage> createState() => _TextSearchPageState();
}

class _TextSearchPageState extends State<TextSearchPage> {
  final _controller = TextEditingController();
  final _similarityService = MockSimilarityService();
  Timer? _debounce;
  bool _isLoading = false;
  String _query = "";
  String? _lastQuery;
  ScanResult? _foundResult;
  List<SimilarItem> _suggestions = [];
  List<SimilarItem> _liveResults = [];
  bool _showNoMatch = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = context.read<AppState>();
      if (appState.selectedCity == null) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const CityPickerPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _query = value;
    _showNoMatch = false;
    _debounce?.cancel();
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      setState(() {
        _foundResult = null;
        _suggestions = [];
        _liveResults = [];
        _showNoMatch = false;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _runLiveSearch(trimmed);
    });
  }

  Future<void> _runSearch(
    String query, {
    bool force = false,
    required bool explicit,
  }) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return;
    }
    _query = trimmed;
    if (!force && _lastQuery == trimmed) {
      return;
    }
    _lastQuery = trimmed;
    final appState = context.read<AppState>();
    final city = appState.selectedCity;
    if (city == null) {
      if (!mounted) {
        return;
      }
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const CityPickerPage()),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _showNoMatch = false;
      _liveResults = [];
    });

    try {
      final uri = Uri.parse(
        "${ApiConfig.baseUrl}/resolve?city=${city.id}"
        "&lang=${appState.locale.languageCode}"
        "&item_name=${Uri.encodeComponent(trimmed)}",
      );
      final headers = await appState.authHeaders();
      final response = await http.get(uri, headers: headers);
      final statusOk = response.statusCode >= 200 && response.statusCode < 300;
      final body = json.decode(response.body) as Map<String, dynamic>;
      if (!mounted || trimmed != _query.trim()) {
        return;
      }
      final item = body["item"];
      final notFound = item == null || body["error"] == "item_not_found";
      if (notFound || !statusOk) {
        if (!explicit) {
          setState(() {
            _foundResult = null;
            _suggestions = [];
            _showNoMatch = false;
            _liveResults = [];
            _isLoading = false;
          });
          return;
        }
        final similar = _similarityFromApi(body, city.id, trimmed);
        setState(() {
          _foundResult = null;
          _suggestions = similar;
          _showNoMatch = true;
          _liveResults = [];
          _isLoading = false;
        });
        return;
      }

      final result = _resultFromBody(body, trimmed);
      setState(() {
        _foundResult = result;
        _suggestions = [];
        _showNoMatch = false;
        _liveResults = [];
        _isLoading = false;
      });
    } catch (_) {
      if (!explicit) {
        if (!mounted || trimmed != _query.trim()) {
          return;
        }
        setState(() {
          _foundResult = null;
          _suggestions = [];
          _showNoMatch = false;
          _liveResults = [];
          _isLoading = false;
        });
        return;
      }
      final similar = _similarityService.getTop3Similar(
        cityId: city.id,
        queryText: trimmed,
        imageBytes: null,
      );
      if (!mounted || trimmed != _query.trim()) {
        return;
      }
      setState(() {
        _foundResult = null;
        _suggestions = similar;
        _showNoMatch = true;
        _liveResults = [];
        _isLoading = false;
      });
    }
  }

  Future<void> _runLiveSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return;
    }
    _query = trimmed;
    final appState = context.read<AppState>();
    final lang = appState.locale.languageCode;
    final cityId = appState.selectedCity?.id;
    if (cityId == null) {
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const CityPickerPage()),
        );
      }
      return;
    }
    setState(() {
      _isLoading = true;
      _showNoMatch = false;
      _foundResult = null;
      _suggestions = [];
    });
    try {
      final uri = Uri.parse(
        "${ApiConfig.baseUrl}/items/search?city=$cityId&lang=$lang&limit=10"
        "&q=${Uri.encodeComponent(trimmed)}",
      );
      final headers = await appState.authHeaders();
      final response = await http.get(uri, headers: headers);
      final statusOk = response.statusCode >= 200 && response.statusCode < 300;
      final body = json.decode(response.body) as Map<String, dynamic>;
      if (!mounted || trimmed != _query.trim()) {
        return;
      }
      if (!statusOk) {
        setState(() {
          _liveResults = [];
          _isLoading = false;
        });
        return;
      }
      final items = (body["items"] as List<dynamic>? ?? []);
      final results = items.map((entry) {
        if (entry is Map<String, dynamic>) {
          final title =
              (entry["title"] ?? entry["canonical_key"] ?? "unknown").toString();
          final disposals = (entry["disposals"] as List<dynamic>? ?? [])
              .map((label) => label.toString())
              .where((label) => label.trim().isNotEmpty)
              .toList();
          return SimilarItem(
            itemId: entry["id"]?.toString(),
            itemTitle: title,
            aliasTitle: null,
            confidence: ConfidenceLevel.low,
            hintCategory: "unknown",
            disposalLabels: disposals,
          );
        }
        return SimilarItem(
          itemId: null,
          itemTitle: entry.toString(),
          aliasTitle: null,
          confidence: ConfidenceLevel.low,
          hintCategory: "unknown",
          disposalLabels: const [],
        );
      }).toList();
      setState(() {
        _liveResults = results;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted || trimmed != _query.trim()) {
        return;
      }
      setState(() {
        _liveResults = [];
        _isLoading = false;
      });
    }
  }

  ScanResult _resultFromBody(Map<String, dynamic> body, String query) {
    final item = body["item"] as Map<String, dynamic>;
    final recycle = body["recycle"] as Map<String, dynamic>? ?? {};
    final disposals = (recycle["disposals"] as List<dynamic>?) ?? [];
    final disposalLabel = disposals.isNotEmpty
        ? (disposals.first["label"]?.toString() ??
            disposals.first["code"]?.toString())
        : null;
    final warningsRaw = (body["warnings"] as List<dynamic>?) ?? [];
    final warnings = warningsRaw
        .map(
          (entry) => Warning(
            severity: WarningSeverity.warn,
            messageKey: entry.toString(),
          ),
        )
        .toList();

    return ScanResult(
      state: ScanState.found,
      itemId: item["id"]?.toString(),
      itemName: (item["title"] ?? item["name"] ?? item["canonical_key"] ?? query)
          .toString(),
      confidence: ConfidenceLevel.medium,
      description: _cleanHtml(item["description"]?.toString()),
      disposalMethod: disposalLabel,
      disposalSteps: const [],
      categories: _labelsFromList(body["categories"]),
      disposalLabels: _labelsFromList(body["disposals"] ?? disposals),
      bestOption: null,
      otherOptions: const [],
      warnings: warnings,
      similarItems: const [],
      imageBytes: null,
      imageUrl: item["image_url"]?.toString(),
      searchMode: SearchMode.text,
      queryText: query,
    );
  }

  List<String> _labelsFromList(dynamic rawList) {
    final list = (rawList as List<dynamic>?) ?? [];
    return list
        .map((entry) {
          if (entry is Map<String, dynamic>) {
            return (entry["label"] ?? entry["code"] ?? "").toString();
          }
          return entry.toString();
        })
        .where((value) => value.trim().isNotEmpty)
        .toList();
  }

  List<SimilarItem> _similarityFromApi(
    Map<String, dynamic> body,
    String cityId,
    String query,
  ) {
    final suggestions = (body["suggestions"] as List<dynamic>?) ?? [];
    if (suggestions.isEmpty) {
      return _similarityService.getTop3Similar(
        cityId: cityId,
        queryText: query,
        imageBytes: null,
      );
    }
    return suggestions.take(3).map((entry) {
      if (entry is Map<String, dynamic>) {
        final name = (entry["title"] ??
                entry["label"] ??
                entry["item_name"] ??
                entry["canonical_key"] ??
                entry["item_id"] ??
                "unknown")
            .toString();
        final alias = (entry["alias"] ??
                entry["alias_text"] ??
                entry["label"] ??
                entry["item_name"] ??
                entry["title"])
            ?.toString();
        final disposals = _labelsFromList(
          entry["disposals"] ?? entry["disposal_labels"],
        );
        return SimilarItem(
          itemId: entry["item_id"]?.toString(),
          itemTitle: name,
          aliasTitle: alias,
          confidence: ConfidenceLevel.medium,
          hintCategory: entry["category"]?.toString() ?? "unknown",
          disposalLabels: disposals,
        );
      }
      return SimilarItem(
        itemId: null,
        itemTitle: entry.toString(),
        aliasTitle: entry.toString(),
        confidence: ConfidenceLevel.low,
        hintCategory: "unknown",
        disposalLabels: const [],
      );
    }).toList();
  }

  String? _cleanHtml(String? input) {
    if (input == null || input.trim().isEmpty) {
      return null;
    }
    var text = input
        .replaceAll(RegExp(r"<br\s*/?>", caseSensitive: false), "\n")
        .replaceAll(RegExp(r"</p>", caseSensitive: false), "\n")
        .replaceAll(RegExp(r"<p[^>]*>", caseSensitive: false), "\n")
        .replaceAll(RegExp(r"<[^>]+>"), " ");
    text = text
        .replaceAll("&nbsp;", " ")
        .replaceAll("&amp;", "&")
        .replaceAll("&quot;", "\"")
        .replaceAll("&#39;", "'")
        .replaceAll("&lt;", "<")
        .replaceAll("&gt;", ">");
    text = text.replaceAll(RegExp(r"\s+"), " ").trim();
    return text.isEmpty ? null : text;
  }

  Future<void> _openResult(ScanResult result) async {
    if (!mounted) {
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ResultPage(result: result)),
    );
  }

  Future<void> _resolveSuggestion(SimilarItem item) async {
    final appState = context.read<AppState>();
    final cityId = appState.selectedCity?.id ?? "hannover";
    final lang = appState.locale.languageCode;
    if (item.itemId == null || item.itemId!.isEmpty) {
      return;
    }
    try {
      final uri = Uri.parse(
        "${ApiConfig.baseUrl}/resolve?city=$cityId&lang=$lang"
        "&item_id=${Uri.encodeComponent(item.itemId!)}",
      );
      final headers = await appState.authHeaders();
      final response = await http.get(uri, headers: headers);
      final statusOk = response.statusCode >= 200 && response.statusCode < 300;
      final body = json.decode(response.body) as Map<String, dynamic>;
      final itemJson = body["item"];
      if (!statusOk || itemJson == null || body["error"] == "item_not_found") {
        return;
      }
      final foundResult = _resultFromBody(body, _query.trim());
      await _openResult(foundResult);
    } catch (_) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final hasQuery = _query.trim().isNotEmpty;

    return ListView(
      padding: const EdgeInsets.all(DesignTokens.sectionSpacing),
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: loc.t("scan_text_placeholder"),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _runSearch(
                _controller.text,
                force: true,
                explicit: true,
              ),
            ),
          ),
          onChanged: _onQueryChanged,
          onSubmitted: (value) => _runSearch(
            value,
            force: true,
            explicit: true,
          ),
        ),
        if (_isLoading) ...[
          const SizedBox(height: DesignTokens.baseSpacing),
          const LinearProgressIndicator(),
        ],
        if (_foundResult != null) ...[
          const SizedBox(height: DesignTokens.sectionSpacing),
          SectionTitle(title: loc.t("result_recognized")),
          const SizedBox(height: DesignTokens.baseSpacing),
          SimilarItemCard(
            item: SimilarItem(
              itemId: _foundResult!.itemId,
              itemTitle: _foundResult!.itemName ?? _query,
              aliasTitle: null,
              confidence: _foundResult!.confidence,
              hintCategory: _foundResult!.categories.isNotEmpty
                  ? _foundResult!.categories.first
                  : "unknown",
              disposalLabels: _foundResult!.disposalLabels,
            ),
            onTap: () => _openResult(_foundResult!),
          ),
        ],
        if (_foundResult == null &&
            _liveResults.isNotEmpty &&
            !_isLoading &&
            !_showNoMatch) ...[
          const SizedBox(height: DesignTokens.sectionSpacing),
          ..._liveResults.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.baseSpacing),
              child: SimilarItemCard(
                item: item,
                onTap: () => _resolveSuggestion(item),
              ),
            ),
          ),
        ],
        if (_foundResult == null && hasQuery && !_isLoading && _showNoMatch) ...[
          const SizedBox(height: DesignTokens.sectionSpacing),
          Text(
            loc.t("no_match_title"),
            style: DesignTokens.titleL.copyWith(color: colorScheme.onSurface),
          ),
          const SizedBox(height: 6),
          Text(
            loc.t("no_match_subtitle"),
            style: DesignTokens.body.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: DesignTokens.baseSpacing),
          _buildHintCard(loc),
          if (_suggestions.isNotEmpty) ...[
            const SizedBox(height: DesignTokens.sectionSpacing),
            SectionTitle(title: loc.t("similar_suggestions")),
            const SizedBox(height: DesignTokens.baseSpacing),
            ..._suggestions.map(
              (item) => Padding(
                padding:
                    const EdgeInsets.only(bottom: DesignTokens.baseSpacing),
                child: SimilarItemCard(
                  item: item,
                  onTap: () => _resolveSuggestion(item),
                ),
              ),
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildHintCard(AppLocalizations loc) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(DesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadius),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.t("warning_info"),
            style: DesignTokens.titleM.copyWith(color: colorScheme.onSurface),
          ),
          const SizedBox(height: 6),
          Text(
            loc.t("hint_text_mode_text"),
            style: DesignTokens.body.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
