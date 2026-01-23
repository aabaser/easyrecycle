import "dart:convert";
import "dart:typed_data";

import "package:file_picker/file_picker.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:http/http.dart" as http;
import "package:provider/provider.dart";

import "../l10n/app_localizations.dart";
import "../models/scan_result.dart";
import "../models/similar_item.dart";
import "../models/warning.dart";
import "../services/mock_rules_service.dart";
import "../services/mock_similarity_service.dart";
import "../services/mock_vision_service.dart";
import "../services/rules_service.dart";
import "../services/vision_service.dart";
import "../state/app_state.dart";
import "../theme/design_tokens.dart";
import "../widgets/city_pill.dart";
import "../widgets/max_width_center.dart";
import "../widgets/primary_button.dart";
import "../widgets/secondary_button.dart";
import "result_page.dart";
import "city_picker_page.dart";
import "language_picker_page.dart";

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final _visionService = MockVisionService();
  final _rulesService = MockRulesService();
  final _similarityService = MockSimilarityService();
  static const String _apiBaseUrl = "http://localhost:8000";

  Uint8List? _imageBytes;
  String _queryText = "";
  bool _isLoading = false;
  String? _analyzeJson;
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _imageBytes = null;
    _queryText = "";
    _analyzeJson = null;
    _textController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = context.read<AppState>();
      if (appState.selectedCity == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CityPickerPage()),
        );
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final appState = context.read<AppState>();
    if (appState.lastResult != null) {
      appState.setLastResult(null);
      if (!mounted) {
        return;
      }
      setState(() {
        _imageBytes = null;
        _analyzeJson = null;
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );
      final bytes = result?.files.single.bytes;
      if (bytes == null) {
        return;
      }
      setState(() {
        _imageBytes = bytes;
      });
      await _runAnalyze();
      return;
    }

    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.camera);
    if (file == null) {
      return;
    }
    final bytes = await file.readAsBytes();
    setState(() {
      _imageBytes = bytes;
    });
    await _runAnalyze();
  }

  Future<void> _pickGallery() async {
    if (kIsWeb) {
      await _pickImage();
      return;
    }

    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) {
      return;
    }
    final bytes = await file.readAsBytes();
    setState(() {
      _imageBytes = bytes;
    });
    await _runAnalyze();
  }

  String _localizedItemName(String keyOrName, AppLocalizations loc) {
    if (loc.hasKey(keyOrName)) {
      return loc.t(keyOrName);
    }
    return keyOrName;
  }

  List<SimilarItem> _localizeSimilarItems(
    List<SimilarItem> items,
    AppLocalizations loc,
  ) {
    return items
        .map(
          (item) => SimilarItem(
            itemId: item.itemId,
            itemTitle: _localizedItemName(item.itemTitle, loc),
            aliasTitle: item.aliasTitle != null
                ? _localizedItemName(item.aliasTitle!, loc)
                : null,
            confidence: item.confidence,
            hintCategory: item.hintCategory,
            disposalLabels: item.disposalLabels,
          ),
        )
        .toList();
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

  Future<void> _runScan() async {
    final appState = context.read<AppState>();
    final city = appState.selectedCity;
    if (city == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final query = _textController.text.trim();
    _queryText = query;
    if (query.isEmpty && _imageBytes == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    if (query.isNotEmpty) {
      setState(() {
        _imageBytes = null;
      });
      await _runTextSearch(query, city.id, appState.locale.languageCode);
      return;
    }

    final inference = await _visionService.infer(
      cityId: city.id,
      imageBytes: _imageBytes,
      queryText: query.isEmpty ? null : query,
    );

    final loc = AppLocalizations.of(context);

    if (inference.category == "unknown") {
      final similar = _similarityService.getTop3Similar(
        cityId: city.id,
        queryText: _queryText,
        imageBytes: _imageBytes,
      );
      final result = ScanResult(
        state: ScanState.notFound,
        itemId: null,
        itemName: null,
        confidence: ConfidenceLevel.low,
        description: null,
        disposalMethod: null,
        disposalSteps: [],
        categories: const [],
        disposalLabels: const [],
        bestOption: null,
        otherOptions: [],
        warnings: [
          Warning(severity: WarningSeverity.warn, messageKey: "no_match_message"),
        ],
        similarItems: _localizeSimilarItems(similar, loc),
        imageBytes: _imageBytes,
        searchMode: SearchMode.image,
        queryText: null,
      );
      appState.setLastResult(result);
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ResultPage(result: result)),
      );
      return;
    }

    try {
      final resolution = _rulesService.resolveFound(
        cityId: city.id,
        inference: inference,
      );

      final itemName = _localizedItemName(
        inference.itemName ?? "",
        loc,
      );

      final result = ScanResult(
        state: ScanState.found,
        itemId: null,
        itemName: itemName,
        confidence: inference.confidence,
        description: null,
        disposalMethod: resolution.disposalMethod,
        disposalSteps: resolution.disposalSteps,
        categories: const [],
        disposalLabels: [resolution.disposalMethod],
        bestOption: resolution.bestOption,
        otherOptions: resolution.otherOptions,
        warnings: resolution.warnings,
        similarItems: [],
        imageBytes: _imageBytes,
        searchMode: SearchMode.image,
        queryText: null,
      );
      appState.setLastResult(result);
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ResultPage(result: result)),
      );
    } on CityRulesMissingException {
      final similar = _similarityService.getTop3Similar(
        cityId: city.id,
        queryText: _queryText,
        imageBytes: _imageBytes,
      );
      final result = ScanResult(
        state: ScanState.notFound,
        itemId: null,
        itemName: null,
        confidence: ConfidenceLevel.low,
        description: null,
        disposalMethod: null,
        disposalSteps: [],
        categories: const [],
        disposalLabels: const [],
        bestOption: null,
        otherOptions: [],
        warnings: [
          Warning(severity: WarningSeverity.warn, messageKey: "no_match_message"),
        ],
        similarItems: _localizeSimilarItems(similar, loc),
        imageBytes: _imageBytes,
        searchMode: SearchMode.image,
        queryText: null,
      );
      appState.setLastResult(result);
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ResultPage(result: result)),
      );
    }
  }

  Future<void> _runAnalyze() async {
    final appState = context.read<AppState>();
    final city = appState.selectedCity;
    if (city == null) {
      return;
    }
    if (_imageBytes == null) {
      return;
    }

    setState(() {
      _isLoading = true;
      _analyzeJson = null;
    });

    try {
      final uri = Uri.parse("$_apiBaseUrl/analyze");
      final response = await http.post(
        uri,
        headers: const {"Content-Type": "application/json"},
        body: json.encode({
          "city": city.id,
          "lang": appState.locale.languageCode,
          "image_base64": base64Encode(_imageBytes!),
        }),
      );
      final statusOk = response.statusCode >= 200 && response.statusCode < 300;
      final body = json.decode(response.body) as Map<String, dynamic>;
      final pretty = const JsonEncoder.withIndent("  ").convert(body);
      setState(() {
        _analyzeJson = pretty;
      });

      final item = body["item"];
      final notFound = item == null || body["error"] == "item_not_found";
      if (notFound && !statusOk) {
        throw Exception("Analyze failed");
      }
      final loc = AppLocalizations.of(context);
      if (notFound) {
        final similar = _similarityFromApi(body, city.id);
        final result = ScanResult(
          state: ScanState.notFound,
          itemId: null,
          itemName: null,
          confidence: ConfidenceLevel.low,
          description: null,
          disposalMethod: null,
          disposalSteps: const [],
          categories: const [],
          disposalLabels: const [],
          bestOption: null,
          otherOptions: const [],
          warnings: [
            Warning(severity: WarningSeverity.warn, messageKey: "no_match_message"),
          ],
          similarItems: _localizeSimilarItems(similar, loc),
          imageBytes: _imageBytes,
          searchMode: SearchMode.image,
          queryText: null,
        );
        appState.setLastResult(result);
        if (!mounted) {
          return;
        }
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ResultPage(result: result)),
        );
        return;
      }

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
      final result = ScanResult(
        state: ScanState.found,
        itemId: item["id"]?.toString(),
        itemName: (item["title"] ?? item["name"] ?? item["canonical_key"] ?? "")
            .toString(),
        confidence: ConfidenceLevel.medium,
        description: _cleanHtml(item["description"]?.toString()),
        disposalMethod: disposalLabel,
        disposalSteps: const [],
        categories: _labelsFromList(body["categories"] ?? item["categories"]),
        disposalLabels: _labelsFromList(body["disposals"] ?? disposals),
        bestOption: null,
        otherOptions: const [],
        warnings: warnings,
        similarItems: const [],
        imageBytes: _imageBytes,
        searchMode: SearchMode.image,
        queryText: null,
      );
      appState.setLastResult(result);
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ResultPage(result: result)),
      );
    } catch (_) {
      setState(() {
        _analyzeJson = "{\"error\":\"analyze_failed\"}";
        _isLoading = false;
      });
    }
  }

  Future<void> _runTextSearch(String query, String cityId, String lang) async {
    final appState = context.read<AppState>();
    final loc = AppLocalizations.of(context);
    try {
      final uri = Uri.parse(
        "$_apiBaseUrl/resolve?city=$cityId&lang=$lang&item_name=${Uri.encodeComponent(query)}",
      );
      final response = await http.get(uri);
      final statusOk = response.statusCode >= 200 && response.statusCode < 300;
      final body = json.decode(response.body) as Map<String, dynamic>;
      final item = body["item"];
      final notFound = item == null || body["error"] == "item_not_found";
      if (notFound && !statusOk) {
        throw Exception("Resolve failed");
      }
      if (notFound) {
        final similar = _similarityFromApi(body, cityId);
        final result = ScanResult(
          state: ScanState.notFound,
          itemId: null,
          itemName: null,
          confidence: ConfidenceLevel.low,
          description: null,
          disposalMethod: null,
          disposalSteps: [],
          categories: const [],
          disposalLabels: const [],
          bestOption: null,
          otherOptions: [],
          warnings: [
            Warning(severity: WarningSeverity.warn, messageKey: "no_match_message"),
          ],
          similarItems: _localizeSimilarItems(similar, loc),
          imageBytes: null,
          searchMode: SearchMode.text,
          queryText: query,
        );
        appState.setLastResult(result);
        if (!mounted) {
          return;
        }
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ResultPage(result: result)),
        );
        return;
      }

      final recycle = body["recycle"] as Map<String, dynamic>?;
      final disposals = (recycle?["disposals"] as List<dynamic>?) ?? [];
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

      final result = ScanResult(
        state: ScanState.found,
        itemId: item["id"]?.toString(),
        itemName: (item["title"] ?? item["name"] ?? item["canonical_key"] ?? query)
            .toString(),
        confidence: ConfidenceLevel.medium,
        description: _cleanHtml(item["description"]?.toString()),
        disposalMethod: disposalLabel,
        disposalSteps: const [],
        categories: _labelsFromList(body["categories"]),
        disposalLabels: _labelsFromList(body["disposals"]),
        bestOption: null,
        otherOptions: const [],
        warnings: warnings,
        similarItems: const [],
        imageBytes: null,
        searchMode: SearchMode.text,
        queryText: query,
      );
      appState.setLastResult(result);
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ResultPage(result: result)),
      );
    } catch (_) {
      final similar = _similarityService.getTop3Similar(
        cityId: cityId,
        queryText: query,
        imageBytes: _imageBytes,
      );
      final result = ScanResult(
        state: ScanState.notFound,
        itemId: null,
        itemName: null,
        confidence: ConfidenceLevel.low,
        description: null,
        disposalMethod: null,
        disposalSteps: [],
        categories: const [],
        disposalLabels: const [],
        bestOption: null,
        otherOptions: [],
        warnings: [
          Warning(severity: WarningSeverity.warn, messageKey: "no_match_message"),
        ],
        similarItems: _localizeSimilarItems(similar, loc),
        imageBytes: null,
        searchMode: SearchMode.text,
        queryText: query,
      );
      appState.setLastResult(result);
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ResultPage(result: result)),
      );
    }
  }

  List<SimilarItem> _similarityFromApi(Map<String, dynamic> body, String cityId) {
    final suggestions = (body["suggestions"] as List<dynamic>?) ?? [];
    if (suggestions.isEmpty) {
      return _similarityService.getTop3Similar(
        cityId: cityId,
        queryText: _queryText,
        imageBytes: _imageBytes,
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
        final disposals = _labelsFromList(entry["disposals"] ?? entry["disposal_labels"]);
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

  List<String> _labelsFromList(dynamic rawList) {
    final list = (rawList as List<dynamic>?) ?? [];
    return list.map((entry) {
      if (entry is Map<String, dynamic>) {
        return (entry["label"] ?? entry["code"] ?? "").toString();
      }
      return entry.toString();
    }).where((value) => value.trim().isNotEmpty).toList();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final appState = context.watch<AppState>();
    final colorScheme = Theme.of(context).colorScheme;
    final city = appState.selectedCity;
    final cityLabel = city == null
        ? ""
        : (city.id == "berlin"
            ? loc.t("city_berlin")
            : loc.t("city_hannover"));

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.t("scan_title"), style: DesignTokens.titleM),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: DesignTokens.baseSpacing),
            child: CityPill(
              label: appState.locale.languageCode.toUpperCase(),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LanguagePickerPage()),
                );
              },
            ),
          ),
          if (city != null)
            Padding(
              padding: const EdgeInsets.only(right: DesignTokens.baseSpacing),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 18),
                  const SizedBox(width: 6),
                  CityPill(
                    label: cityLabel,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const CityPickerPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
      body: MaxWidthCenter(
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.sectionSpacing),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(DesignTokens.cornerRadius),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 52,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: DesignTokens.sectionSpacing),
                PrimaryButton(
                  label: loc.t("scan_take_photo"),
                  onPressed: _isLoading ? null : _pickImage,
                ),
                const SizedBox(height: DesignTokens.baseSpacing),
                SecondaryButton(
                  label: kIsWeb ? loc.t("scan_upload") : loc.t("scan_pick_gallery"),
                  onPressed: _isLoading ? null : _pickGallery,
                ),
                const SizedBox(height: DesignTokens.sectionSpacing),
                TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: loc.t("scan_text_placeholder"),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _isLoading
                          ? null
                          : () {
                              _runScan();
                            },
                    ),
                  ),
                  onChanged: (value) {
                    _queryText = value;
                  },
                ),
                if (_isLoading) ...[
                  const SizedBox(height: DesignTokens.sectionSpacing),
                  const Center(child: CircularProgressIndicator()),
                ],
                if (_analyzeJson != null) ...[
                  const SizedBox(height: DesignTokens.sectionSpacing),
                  Text(
                    loc.t("debug_json_title"),
                    style: DesignTokens.titleM.copyWith(color: colorScheme.onSurface),
                  ),
                  const SizedBox(height: DesignTokens.baseSpacing),
                  Container(
                    padding: const EdgeInsets.all(DesignTokens.cardPadding),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(DesignTokens.cornerRadius),
                      border: Border.all(color: colorScheme.outline),
                    ),
                    child: Text(
                      _analyzeJson!,
                      style: DesignTokens.caption.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
