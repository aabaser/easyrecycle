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
import "../state/app_state.dart";
import "../theme/design_tokens.dart";
import "../widgets/similar_item_card.dart";
import "../ui/components/er_search_bar.dart";
import "../ui/components/er_section.dart";
import "city_picker_page.dart";
import "recycle_centers_page.dart";
import "result_page.dart";

class TextSearchPage extends StatefulWidget {
  const TextSearchPage({super.key});

  @override
  TextSearchPageState createState() => TextSearchPageState();
}

class TextSearchPageState extends State<TextSearchPage> {
  final _controller = TextEditingController();
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

  void setActive(bool active) {}

  void resetForCityChange() {
    _debounce?.cancel();
    _controller.clear();
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = false;
      _query = "";
      _lastQuery = null;
      _foundResult = null;
      _suggestions = [];
      _liveResults = [];
      _showNoMatch = false;
    });
  }

  void _showConnectionError() {
    if (!mounted) {
      return;
    }
    final loc = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.hideCurrentSnackBar();
    messenger?.showSnackBar(
      SnackBar(content: Text(loc.t("connection_error_message"))),
    );
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
        final similar = _similarityFromApi(body);
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
      if (!mounted || trimmed != _query.trim()) {
        return;
      }
      setState(() {
        _foundResult = null;
        _suggestions = const [];
        _showNoMatch = false;
        _liveResults = [];
        _isLoading = false;
      });
      _showConnectionError();
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
          final title = _pickDisplayName(entry);
          final disposals = (entry["disposals"] as List<dynamic>? ?? [])
              .map((value) {
                if (value is Map<String, dynamic>) {
                  return (value["label"] ?? value["code"] ?? "").toString();
                }
                return value.toString();
              })
              .where((label) => label.trim().isNotEmpty)
              .toList();
          final disposalCodes = (entry["disposals"] as List<dynamic>? ?? [])
              .map((value) {
                if (value is Map<String, dynamic>) {
                  return (value["code"] ?? "").toString();
                }
                return "";
              })
              .where((code) => code.trim().isNotEmpty)
              .toList();
          final explicitCodes =
              (entry["disposal_codes"] as List<dynamic>? ?? [])
                  .map((e) => e.toString())
                  .where((code) => code.trim().isNotEmpty)
                  .toList();
          final allCodes =
              <String>{...disposalCodes, ...explicitCodes}.toList();
          return SimilarItem(
            itemId: entry["id"]?.toString(),
            itemTitle: title,
            aliasTitle: null,
            confidence: ConfidenceLevel.low,
            hintCategory: "unknown",
            disposalLabels: disposals,
            disposalCodes: allCodes,
            imageUrl: _pickImageUrl(entry),
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
      itemName:
          (item["title"] ?? item["name"] ?? item["canonical_key"] ?? query)
              .toString(),
      confidence: ConfidenceLevel.medium,
      description: _cleanHtml(item["description"]?.toString()),
      disposalMethod: disposalLabel,
      disposalSteps: const [],
      categories: _labelsFromList(body["categories"]),
      disposalLabels: _labelsFromList(body["disposals"] ?? disposals),
      disposalCodes: _codesFromList(body["disposals"] ?? disposals),
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

  List<String> _codesFromList(dynamic rawList) {
    final list = (rawList as List<dynamic>?) ?? [];
    return list
        .map((entry) {
          if (entry is Map<String, dynamic>) {
            return (entry["code"] ?? "").toString();
          }
          if (entry is String) {
            return entry;
          }
          return "";
        })
        .where((value) => value.trim().isNotEmpty)
        .toList();
  }

  List<SimilarItem> _similarityFromApi(
    Map<String, dynamic> body,
  ) {
    final suggestions = (body["suggestions"] as List<dynamic>?) ?? [];
    if (suggestions.isEmpty) {
      return const [];
    }
    return suggestions.take(3).map((entry) {
      if (entry is Map<String, dynamic>) {
        final name = _pickDisplayName(entry);
        final alias = _pickAliasName(entry);
        final disposals = _labelsFromList(
          entry["disposals"] ?? entry["disposal_labels"],
        );
        final disposalCodes = _codesFromList(
          entry["disposals"] ?? entry["disposal_codes"],
        );
        return SimilarItem(
          itemId: entry["item_id"]?.toString(),
          itemTitle: name,
          aliasTitle: alias,
          confidence: ConfidenceLevel.medium,
          hintCategory: entry["category"]?.toString() ?? "unknown",
          disposalLabels: disposals,
          disposalCodes: disposalCodes,
          imageUrl: _pickImageUrl(entry),
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

  String _pickDisplayName(Map<String, dynamic> entry) {
    final primaryCandidates = <dynamic>[
      entry["label"],
      entry["item_name"],
      entry["name"],
      entry["display_name"],
      entry["alias"],
      entry["alias_text"],
    ];
    for (final candidate in primaryCandidates) {
      final text = _cleanCandidateText(candidate);
      if (text != null) {
        return text;
      }
    }

    final fallbackCandidates = <dynamic>[
      entry["title"],
      entry["canonical_key"],
      entry["item_id"],
      entry["id"],
    ];
    String? idLikeFallback;
    for (final candidate in fallbackCandidates) {
      final text = _cleanCandidateText(candidate);
      if (text == null) {
        continue;
      }
      if (!_looksLikeInternalId(text)) {
        return text;
      }
      idLikeFallback ??= text;
    }
    return idLikeFallback ?? "unknown";
  }

  String? _pickImageUrl(Map<String, dynamic> entry) {
    final candidates = <dynamic>[
      entry["image_url"],
      entry["imageUrl"],
      entry["thumbnail_url"],
      entry["thumbnailUrl"],
      entry["primary_image_url"],
      entry["primaryImageUrl"],
    ];
    for (final candidate in candidates) {
      final text = _cleanCandidateText(candidate);
      if (text != null) {
        return text;
      }
    }
    return null;
  }

  String? _pickAliasName(Map<String, dynamic> entry) {
    final aliasCandidates = <dynamic>[
      entry["alias"],
      entry["alias_text"],
      entry["label"],
      entry["item_name"],
      entry["name"],
      entry["title"],
    ];
    for (final candidate in aliasCandidates) {
      final text = _cleanCandidateText(candidate);
      if (text != null) {
        return text;
      }
    }
    return null;
  }

  String? _cleanCandidateText(dynamic value) {
    final text = value?.toString().trim() ?? "";
    if (text.isEmpty || text.toLowerCase() == "null") {
      return null;
    }
    return text;
  }

  bool _looksLikeInternalId(String text) {
    final lower = text.toLowerCase();
    if (RegExp(r"^[0-9a-f]{8}-[0-9a-f-]{27,}$").hasMatch(lower)) {
      return true;
    }
    if (RegExp(r"^\d{6,}$").hasMatch(lower)) {
      return true;
    }
    if (lower.contains("_") &&
        !lower.contains(" ") &&
        RegExp(r"^[a-z0-9_]+$").hasMatch(lower)) {
      return true;
    }
    return false;
  }

  String? _cleanHtml(String? input) {
    if (input == null || input.trim().isEmpty) {
      return null;
    }
    var text = input
        .replaceAll(RegExp(r"<br\s*/?>", caseSensitive: false), "\n")
        .replaceAll(RegExp(r"</p>", caseSensitive: false), "\n")
        .replaceAll(RegExp(r"<p[^>]*>", caseSensitive: false), "\n")
        .replaceAll(RegExp(r"</li>", caseSensitive: false), "\n")
        .replaceAll(RegExp(r"<li[^>]*>", caseSensitive: false), "- ")
        .replaceAll(RegExp(r"<[^>]+>"), " ");
    text = text
        .replaceAll("&nbsp;", " ")
        .replaceAll("&amp;", "&")
        .replaceAll("&quot;", "\"")
        .replaceAll("&#39;", "'")
        .replaceAll("&lt;", "<")
        .replaceAll("&gt;", ">");
    text = text.replaceAll("\r\n", "\n").replaceAll("\r", "\n");
    text = text.replaceAll(RegExp(r"[^\S\n]+"), " ");
    text = text.replaceAll(RegExp(r" *\n *"), "\n");
    text = text.replaceAll(RegExp(r"\n{3,}"), "\n\n");
    text = text.trim();
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
      _showConnectionError();
      return;
    }
  }

  void _openRecycleCenters() {
    final cityCode = context.read<AppState>().selectedCity?.id ?? "hannover";
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RecycleCentersPage(cityCode: cityCode),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final hasQuery = _query.trim().isNotEmpty;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ERSearchBar(
                controller: _controller,
                hintText: loc.t("scan_text_placeholder"),
                dense: true,
                onChanged: _onQueryChanged,
                onSubmitted: (value) => _runSearch(
                  value,
                  force: true,
                  explicit: true,
                ),
                onSearchTap: () => _runSearch(
                  _controller.text,
                  force: true,
                  explicit: true,
                ),
              ),
              if (_isLoading) ...[
                const SizedBox(height: 12),
                const LinearProgressIndicator(),
              ],
            ],
          ),
        ),
        Expanded(
          child: ListView(
            key: const PageStorageKey<String>("tab_text_list"),
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            children: [
              const SizedBox(height: 10),
              if (_foundResult != null) ...[
                ERSection(
                  title: loc.t("result_recognized"),
                  child: SimilarItemCard(
                    item: SimilarItem(
                      itemId: _foundResult!.itemId,
                      itemTitle: _foundResult!.itemName ?? _query,
                      aliasTitle: null,
                      confidence: _foundResult!.confidence,
                      hintCategory: "",
                      disposalLabels: _foundResult!.disposalLabels,
                      disposalCodes: _foundResult!.disposalCodes,
                      imageUrl: _foundResult!.imageUrl,
                    ),
                    findCenterLabel: loc.t("find_recycling_center"),
                    onFindCenterTap: _openRecycleCenters,
                    onTap: () => _openResult(_foundResult!),
                  ),
                ),
              ],
              if (_foundResult == null &&
                  _liveResults.isNotEmpty &&
                  !_isLoading &&
                  !_showNoMatch) ...[
                ..._liveResults.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SimilarItemCard(
                      item: item,
                      findCenterLabel: loc.t("find_recycling_center"),
                      onFindCenterTap: _openRecycleCenters,
                      onTap: () => _resolveSuggestion(item),
                    ),
                  ),
                ),
              ],
              if (_foundResult == null &&
                  hasQuery &&
                  !_isLoading &&
                  _showNoMatch) ...[
                _buildNotFoundSummaryCard(loc),
                if (_suggestions.isNotEmpty) ...[
                  const SizedBox(height: DesignTokens.sectionSpacing),
                  ERSection(
                    title: loc.t("similar_suggestions"),
                    child: Column(
                      children: _suggestions
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: SimilarItemCard(
                                item: item,
                                findCenterLabel: loc.t("find_recycling_center"),
                                onFindCenterTap: _openRecycleCenters,
                                onTap: () => _resolveSuggestion(item),
                              ),
                            ),
                          )
                          .toList(growable: false),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotFoundSummaryCard(AppLocalizations loc) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final radius = BorderRadius.circular(20);

    return ClipRRect(
      borderRadius: radius,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: radius,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.12,
                  child: Image.asset(
                    "assets/uix/bg_top_abstract.png",
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.05),
                      colorScheme.surface.withValues(alpha: 0.02),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer
                              .withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.search_off_rounded,
                          color: colorScheme.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.t("no_match_title"),
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              loc.t("no_match_subtitle"),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Divider(
                    height: 1,
                    color: colorScheme.outlineVariant.withValues(alpha: 0.8),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    loc.t("warning_info"),
                    style: DesignTokens.titleM.copyWith(
                      color: colorScheme.onSurface,
                    ),
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
            ),
          ],
        ),
      ),
    );
  }

}
