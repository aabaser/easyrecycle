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
import "../widgets/similar_item_card.dart";
import "../ui/components/er_search_bar.dart";
import "../ui/components/er_section.dart";
import "city_picker_page.dart";
import "home_shell.dart";
import "recycle_centers_page.dart";
import "result_page.dart";

class TextSearchPage extends StatefulWidget {
  const TextSearchPage({super.key});

  @override
  TextSearchPageState createState() => TextSearchPageState();
}

class TextSearchPageState extends State<TextSearchPage> {
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

  void setActive(bool active) {}

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
          final title = (entry["title"] ?? entry["canonical_key"] ?? "unknown")
              .toString();
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
          return SimilarItem(
            itemId: entry["id"]?.toString(),
            itemTitle: title,
            aliasTitle: null,
            confidence: ConfidenceLevel.low,
            hintCategory: "unknown",
            disposalLabels: disposals,
            disposalCodes: disposalCodes,
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

  void _openRecycleCenters() {
    final cityCode = context.read<AppState>().selectedCity?.id ?? "hannover";
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RecycleCentersPage(cityCode: cityCode),
      ),
    );
  }

  void _openCameraTab() {
    final appState = context.read<AppState>();
    appState.requestTab(HomeShell.tabCamera);
    appState.requestCameraScan();
  }

  Future<void> _openSimilarSuggestionsPage() async {
    final query = _controller.text.trim();
    if (query.isEmpty) {
      return;
    }
    final appState = context.read<AppState>();
    final city = appState.selectedCity;
    if (city == null) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const CityPickerPage()),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });
    try {
      final uri = Uri.parse(
        "${ApiConfig.baseUrl}/resolve?city=${city.id}"
        "&lang=${appState.locale.languageCode}"
        "&item_name=${Uri.encodeComponent(query)}",
      );
      final headers = await appState.authHeaders();
      final response = await http.get(uri, headers: headers);
      final statusOk = response.statusCode >= 200 && response.statusCode < 300;
      final body = json.decode(response.body) as Map<String, dynamic>;
      final item = body["item"];
      final notFound = item == null || body["error"] == "item_not_found";
      if (!notFound && statusOk) {
        final result = _resultFromBody(body, query);
        if (!mounted) {
          return;
        }
        setState(() {
          _isLoading = false;
        });
        await _openResult(result);
        return;
      }

      final similar = _similarityFromApi(body, city.id, query);
      final notFoundResult = ScanResult(
        state: ScanState.notFound,
        itemId: null,
        itemName: null,
        confidence: ConfidenceLevel.low,
        description: null,
        disposalMethod: null,
        disposalSteps: const [],
        categories: const [],
        disposalLabels: const [],
        disposalCodes: const [],
        bestOption: null,
        otherOptions: const [],
        warnings: [
          Warning(
            severity: WarningSeverity.warn,
            messageKey: "no_match_message",
          ),
        ],
        similarItems: similar,
        imageBytes: null,
        imageUrl: null,
        searchMode: SearchMode.text,
        queryText: query,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
      });
      await _openResult(notFoundResult);
    } catch (_) {
      if (!mounted) {
        return;
      }
      final appState = context.read<AppState>();
      final cityId = appState.selectedCity?.id ?? "hannover";
      final fallback = _similarityService.getTop3Similar(
        cityId: cityId,
        queryText: query,
        imageBytes: null,
      );
      final notFoundResult = ScanResult(
        state: ScanState.notFound,
        itemId: null,
        itemName: null,
        confidence: ConfidenceLevel.low,
        description: null,
        disposalMethod: null,
        disposalSteps: const [],
        categories: const [],
        disposalLabels: const [],
        disposalCodes: const [],
        bestOption: null,
        otherOptions: const [],
        warnings: [
          Warning(
            severity: WarningSeverity.warn,
            messageKey: "no_match_message",
          ),
        ],
        similarItems: fallback,
        imageBytes: null,
        imageUrl: null,
        searchMode: SearchMode.text,
        queryText: query,
      );
      setState(() {
        _isLoading = false;
      });
      await _openResult(notFoundResult);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final hasQuery = _query.trim().isNotEmpty;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.t("text_search_title"),
                style: Theme.of(
                  context,
                )
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
              _buildModeChips(loc),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _openRecycleCenters,
                  icon: const Icon(Icons.place_outlined, size: 18),
                  label: Text(loc.t("find_recycling_center")),
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
                      hintCategory: _foundResult!.categories.isNotEmpty
                          ? _foundResult!.categories.first
                          : "unknown",
                      disposalLabels: _foundResult!.disposalLabels,
                      disposalCodes: _foundResult!.disposalCodes,
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
                const SizedBox(height: DesignTokens.baseSpacing),
                Text(
                  loc.t("no_match_title"),
                  style: DesignTokens.titleM
                      .copyWith(color: colorScheme.onSurfaceVariant),
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
              ],
            ],
          ),
        ),
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

  Widget _buildModeChips(AppLocalizations loc) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget buildChip({
      required String label,
      required IconData icon,
      required bool selected,
      required VoidCallback onTap,
    }) {
      return FilterChip(
        selected: selected,
        showCheckmark: false,
        onSelected: (_) => onTap(),
        avatar: Icon(
          icon,
          size: 16,
          color: selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
        ),
        label: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedColor: colorScheme.primaryContainer,
        side: BorderSide(
          color: selected ? colorScheme.primary : colorScheme.outlineVariant,
          width: selected ? 1.1 : 1,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          buildChip(
            label: loc.t("nav_text"),
            icon: Icons.search,
            selected: true,
            onTap: () {},
          ),
          const SizedBox(width: 8),
          buildChip(
            label: loc.t("scan_title"),
            icon: Icons.camera_alt_outlined,
            selected: false,
            onTap: _openCameraTab,
          ),
          const SizedBox(width: 8),
          buildChip(
            label: loc.t("similar_suggestions"),
            icon: Icons.auto_awesome_outlined,
            selected: false,
            onTap: _openSimilarSuggestionsPage,
          ),
        ],
      ),
    );
  }
}
