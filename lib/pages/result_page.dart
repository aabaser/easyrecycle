import "dart:convert";
import "dart:typed_data";

import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:provider/provider.dart";
import "package:url_launcher/url_launcher.dart";

import "../l10n/app_localizations.dart";
import "../models/scan_result.dart";
import "../models/similar_item.dart";
import "../models/warning.dart";
import "../services/mock_rules_service.dart";
import "../services/vision_service.dart";
import "../state/app_state.dart";
import "../theme/design_tokens.dart";
import "../widgets/action_card.dart";
import "../widgets/disposal_chips.dart";
import "../widgets/info_banner.dart";
import "../widgets/max_width_center.dart";
import "../widgets/primary_button.dart";
import "../widgets/section_title.dart";
import "../widgets/similar_item_card.dart";
import "../widgets/city_pill.dart";
import "city_picker_page.dart";
import "language_picker_page.dart";
import "scan_page.dart";

class ResultPage extends StatefulWidget {
  const ResultPage({super.key, required this.result});

  final ScanResult result;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late ScanResult _result;
  final _rulesService = MockRulesService();
  bool _showFullDescription = false;
  int _feedbackValue = 0;
  static const double _bottomBarHeight = 112;
  static const double _notFoundBarHeight = 104;
  static const String _apiBaseUrl = "http://localhost:8000";
  Uint8List? get _effectiveImageBytes =>
      _result.state == ScanState.notFound ? null : _result.imageBytes;
  String? get _effectiveImageUrl {
    if (_result.state == ScanState.notFound) {
      return null;
    }
    if (_result.imageBytes != null) {
      return null;
    }
    return _result.imageUrl;
  }

  @override
  void initState() {
    super.initState();
    _result = widget.result;
  }

  List<InlineSpan> _linkify(
    String text,
    TextStyle style,
    TextStyle linkStyle,
  ) {
    final spans = <InlineSpan>[];
    final regex = RegExp(r"https?:\/\/[^\s]+");
    var currentIndex = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > currentIndex) {
        spans.add(
          TextSpan(text: text.substring(currentIndex, match.start), style: style),
        );
      }

      var url = match.group(0) ?? "";
      var trailing = "";
      while (url.isNotEmpty && RegExp(r"[).,;:]$").hasMatch(url)) {
        trailing = url[url.length - 1] + trailing;
        url = url.substring(0, url.length - 1);
      }

      if (url.isNotEmpty) {
        spans.add(
          TextSpan(
            text: url,
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                final uri = Uri.tryParse(url);
                if (uri == null) {
                  return;
                }
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              },
          ),
        );
      }

      if (trailing.isNotEmpty) {
        spans.add(TextSpan(text: trailing, style: style));
      }

      currentIndex = match.end;
    }

    if (currentIndex < text.length) {
      spans.add(TextSpan(text: text.substring(currentIndex), style: style));
    }

    return spans;
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

  Future<void> _resolveSimilarItem(SimilarItem item) async {
    final appState = context.read<AppState>();
    final cityId = appState.selectedCity?.id ?? "hannover";
    final lang = appState.locale.languageCode;
    if (item.itemId == null || item.itemId!.isEmpty) {
      return;
    }
    try {
      final uri = Uri.parse(
        "$_apiBaseUrl/resolve?city=$cityId&lang=$lang&item_id=${Uri.encodeComponent(item.itemId!)}",
      );
      final response = await http.get(uri);
      final statusOk = response.statusCode >= 200 && response.statusCode < 300;
      final body = json.decode(response.body) as Map<String, dynamic>;
      final itemJson = body["item"];
      if (!statusOk || itemJson == null || body["error"] == "item_not_found") {
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

      final foundResult = ScanResult(
        state: ScanState.found,
        itemId: itemJson["id"]?.toString() ?? item.itemId,
        itemName: (itemJson["title"] ??
                itemJson["name"] ??
                itemJson["canonical_key"] ??
                item.itemTitle)
            .toString(),
        confidence: item.confidence,
        description: _cleanHtml(itemJson["description"]?.toString()),
        disposalMethod: disposalLabel,
        disposalSteps: const [],
        categories: _labelsFromList(body["categories"]),
        disposalLabels: _labelsFromList(body["disposals"]),
        bestOption: null,
        otherOptions: const [],
        warnings: warnings,
        similarItems: const [],
        imageBytes: _effectiveImageBytes,
        imageUrl: itemJson["image_url"]?.toString(),
        searchMode: _result.searchMode,
        queryText: _result.queryText,
      );
      if (!mounted) {
        return;
      }
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ResultPage(result: foundResult)),
      );
      return;
    } catch (_) {
      return;
    }

    final inference = VisionInference(
      itemName: item.itemTitle,
      category: item.hintCategory,
      confidence: item.confidence,
    );

    final resolution = _rulesService.resolveFound(
      cityId: cityId,
      inference: inference,
    );

    final fallbackResult = ScanResult(
      state: ScanState.found,
      itemId: item.itemId,
      itemName: item.itemTitle,
      confidence: item.confidence,
      description: null,
      disposalMethod: resolution.disposalMethod,
      disposalSteps: resolution.disposalSteps,
      categories: const [],
      disposalLabels: [resolution.disposalMethod],
      bestOption: resolution.bestOption,
      otherOptions: resolution.otherOptions,
      warnings: resolution.warnings,
      similarItems: [],
      imageBytes: _effectiveImageBytes,
      imageUrl: _result.imageUrl,
      searchMode: _result.searchMode,
      queryText: _result.queryText,
    );
    if (!mounted) {
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ResultPage(result: fallbackResult)),
    );
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).maybePop();
              return;
            }
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const ScanPage()),
              (route) => false,
            );
          },
        ),
        title: Text(
          _result.state == ScanState.found && _result.itemName != null
              ? _result.itemName!
              : loc.t("app_title"),
          style: DesignTokens.titleM.copyWith(color: colorScheme.onSurface),
        ),
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
                        MaterialPageRoute(builder: (_) => CityPickerPage()),
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
          child: _result.state == ScanState.found
              ? _buildFound(context, loc)
              : _buildNotFound(context, loc),
        ),
      ),
      bottomNavigationBar: _result.state == ScanState.found
          ? _buildFoundBottomBar(loc)
          : _buildNotFoundBottomBar(loc),
    );
  }

  Widget _buildFoundBottomBar(AppLocalizations loc) {
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.sectionSpacing,
          vertical: DesignTokens.baseSpacing,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(top: BorderSide(color: colorScheme.outline)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.cornerRadius),
                  ),
                ),
                onPressed: () => _showInfoDialog(loc),
                child: Text(loc.t("find_recycling_center")),
              ),
            ),
            const SizedBox(height: DesignTokens.baseSpacing),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  side: BorderSide(color: colorScheme.outline),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.cornerRadius),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const ScanPage()),
                    (route) => false,
                  );
                },
                child: Text(loc.t("rescan")),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotFoundBottomBar(AppLocalizations loc) {
    final colorScheme = Theme.of(context).colorScheme;
    final mode = _result.searchMode;
    final primaryLabel = switch (mode) {
      SearchMode.text => loc.t("cta_search_adjust"),
      SearchMode.image => loc.t("rescan"),
      SearchMode.unknown => loc.t("cta_retry"),
    };
    final secondaryLabel = switch (mode) {
      SearchMode.text => loc.t("cta_retry"),
      SearchMode.image => loc.t("cta_enter_text"),
      SearchMode.unknown => loc.t("cta_change_search"),
    };

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.sectionSpacing,
          vertical: DesignTokens.baseSpacing,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(top: BorderSide(color: colorScheme.outline)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.cornerRadius),
                  ),
                ),
                onPressed: () => _handleNotFoundPrimary(mode, loc),
                child: Text(primaryLabel),
              ),
            ),
            const SizedBox(height: DesignTokens.baseSpacing),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  side: BorderSide(color: colorScheme.outline),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.cornerRadius),
                  ),
                ),
                onPressed: () => _handleNotFoundSecondary(mode, loc),
                child: Text(secondaryLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNotFoundPrimary(SearchMode mode, AppLocalizations loc) {
    if (mode == SearchMode.text) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const ScanPage()),
        (route) => false,
      );
      return;
    }
    if (mode == SearchMode.image) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const ScanPage()),
        (route) => false,
      );
      return;
    }
    _showInfoDialog(loc);
  }

  void _handleNotFoundSecondary(SearchMode mode, AppLocalizations loc) {
    if (mode == SearchMode.text) {
      if (_result.queryText != null && _result.queryText!.trim().isNotEmpty) {
        _retryTextSearch(_result.queryText!.trim());
        return;
      }
      _showInfoDialog(loc);
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const ScanPage()),
      (route) => false,
    );
  }

  Future<void> _retryTextSearch(String query) async {
    final appState = context.read<AppState>();
    final cityId = appState.selectedCity?.id ?? "hannover";
    final lang = appState.locale.languageCode;
    try {
      final uri = Uri.parse(
        "$_apiBaseUrl/resolve?city=$cityId&lang=$lang&item_name=${Uri.encodeComponent(query)}",
      );
      final response = await http.get(uri);
      final statusOk = response.statusCode >= 200 && response.statusCode < 300;
      final body = json.decode(response.body) as Map<String, dynamic>;
      final itemJson = body["item"];
      if (!statusOk || itemJson == null || body["error"] == "item_not_found") {
        _showInfoDialog(AppLocalizations.of(context));
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
      final foundResult = ScanResult(
        state: ScanState.found,
        itemId: itemJson["id"]?.toString(),
        itemName: (itemJson["title"] ??
                itemJson["name"] ??
                itemJson["canonical_key"] ??
                query)
            .toString(),
        confidence: ConfidenceLevel.medium,
        description: _cleanHtml(itemJson["description"]?.toString()),
        disposalMethod: disposalLabel,
        disposalSteps: const [],
        categories: _labelsFromList(body["categories"]),
        disposalLabels: _labelsFromList(body["disposals"]),
        bestOption: null,
        otherOptions: const [],
        warnings: warnings,
        similarItems: const [],
        imageBytes: null,
        imageUrl: itemJson["image_url"]?.toString(),
        searchMode: SearchMode.text,
        queryText: query,
      );
      if (!mounted) {
        return;
      }
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ResultPage(result: foundResult)),
      );
    } catch (_) {
      _showInfoDialog(AppLocalizations.of(context));
    }
  }

  void _showInfoDialog(AppLocalizations loc) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.t("info_title")),
        content: Text(loc.t("info_unavailable")),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(loc.t("info_ok")),
          ),
        ],
      ),
    );
  }

  Widget _buildFound(BuildContext context, AppLocalizations loc) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.only(bottom: _bottomBarHeight + 16),
      children: [
        _buildImagePreview(),
        const SizedBox(height: DesignTokens.sectionSpacing),
        Row(
          children: [
            const _LeadingIconBadge(icon: Icons.eco_outlined),
            const SizedBox(width: DesignTokens.baseSpacing),
            Expanded(
              child: Text(
                _result.itemName == null
                    ? ""
                    : _result.categories.isNotEmpty
                        ? "${_result.itemName} (${_result.categories.join(", ")})"
                        : _result.itemName!,
                style: DesignTokens.titleM.copyWith(color: colorScheme.onSurface),
              ),
            ),
          ],
        ),
        const SizedBox(height: DesignTokens.sectionSpacing),
        _buildDisposalCard(loc),
        if (_result.description != null && _result.description!.trim().isNotEmpty) ...[
          const SizedBox(height: DesignTokens.sectionSpacing),
          SectionTitle(title: loc.t("result_description")),
          const SizedBox(height: DesignTokens.baseSpacing),
          _buildDescription(loc, _result.description!),
        ],
        if (_result.bestOption != null) ...[
          const SizedBox(height: DesignTokens.sectionSpacing),
          SectionTitle(
            title: "${loc.t("best_option_title")} ${loc.t(_result.bestOption!.titleKey)}",
          ),
          const SizedBox(height: DesignTokens.baseSpacing),
          ActionCard(option: _result.bestOption!),
        ],
        if (_result.otherOptions.isNotEmpty) ...[
          const SizedBox(height: DesignTokens.sectionSpacing),
          ExpansionTile(
            title: Text(
              loc.t("other_options_title"),
              style: DesignTokens.titleM.copyWith(color: colorScheme.onSurface),
            ),
            children: _result.otherOptions.map((option) {
              return ListTile(
                leading: Icon(
                  Icons.circle,
                  size: 10,
                  color: colorScheme.primary,
                ),
                title: Text(loc.t(option.titleKey)),
                trailing: const Icon(Icons.chevron_right),
              );
            }).toList(),
          ),
        ],
        if (_result.warnings.isNotEmpty) ...[
          const SizedBox(height: DesignTokens.sectionSpacing),
          ..._result.warnings.map(
            (warning) => Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.baseSpacing),
              child: InfoBanner(warning: warning),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildImagePreview() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadius),
        border: Border.all(color: colorScheme.outline),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadius),
        child: _result.imageBytes != null
            ? Image.memory(_result.imageBytes!, fit: BoxFit.cover)
            : (_effectiveImageUrl != null
                ? Image.network(
                    _effectiveImageUrl!.startsWith("http")
                        ? _effectiveImageUrl!
                        : "$_apiBaseUrl${_effectiveImageUrl!}",
                    fit: BoxFit.cover,
                  )
                : Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: colorScheme.primary,
                  )),
      ),
    );
  }

  Widget _buildDisposalCard(AppLocalizations loc) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasLabels = _result.disposalLabels.isNotEmpty;
    final methodText = hasLabels ? "" : (_result.disposalMethod ?? "");
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
          Row(
            children: [
              const _LeadingIconBadge(icon: Icons.delete_outline),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  methodText.isEmpty
                      ? loc.t("disposal_title_prefix")
                      : "${loc.t("disposal_title_prefix")} $methodText",
                  style: DesignTokens.titleM.copyWith(color: colorScheme.onSurface),
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.baseSpacing),
          if (_result.disposalLabels.isNotEmpty)
            DisposalChips(labels: _result.disposalLabels),
          if (_result.disposalLabels.isNotEmpty)
            const SizedBox(height: DesignTokens.baseSpacing),
          _buildFeedbackRow(loc),
          const SizedBox(height: DesignTokens.baseSpacing),
          ..._result.disposalSteps.map(
            (step) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Icon(
                      Icons.circle,
                      size: 8,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(step, style: DesignTokens.body)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(AppLocalizations loc, String description) {
    final normalized = description.trim();
    final hasMore = normalized.length > 140;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: Text.rich(
            TextSpan(
              style: DesignTokens.body,
              children: _linkify(
                normalized,
                DesignTokens.body,
                DesignTokens.body.copyWith(
                  color: colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            maxLines: _showFullDescription ? null : 3,
            overflow: _showFullDescription ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
        ),
        if (hasMore)
          TextButton(
            onPressed: () {
              setState(() {
                _showFullDescription = !_showFullDescription;
              });
            },
            child: Text(
              _showFullDescription
                  ? loc.t("details_hide")
                  : loc.t("details_show"),
            ),
          ),
      ],
    );
  }

  Widget _buildFeedbackRow(AppLocalizations loc) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          loc.t("feedback_prompt"),
          style: DesignTokens.caption.copyWith(
            fontSize: 12,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 6),
        _feedbackButton(
          icon: Icons.thumb_up_outlined,
          isSelected: _feedbackValue == 1,
          onTap: () => _setFeedback(1),
        ),
        const SizedBox(width: 8),
        _feedbackButton(
          icon: Icons.thumb_down_outlined,
          isSelected: _feedbackValue == -1,
          onTap: () => _setFeedback(-1),
        ),
      ],
    );
  }

  Widget _feedbackButton({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        icon,
        size: 18,
        color: isSelected ? colorScheme.primary : colorScheme.onSurface,
      ),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints.tightFor(width: 32, height: 32),
      splashRadius: 16,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          isSelected ? colorScheme.primaryContainer : Colors.transparent,
        ),
      ),
    );
  }

  void _setFeedback(int value) {
    if (_feedbackValue == value) {
      return;
    }
    setState(() {
      _feedbackValue = value;
    });
    _submitFeedback(value);
  }

  Future<void> _submitFeedback(int value) async {
    if (_result.state != ScanState.found) {
      return;
    }
    final itemId = _result.itemId;
    if (itemId == null || itemId.isEmpty) {
      return;
    }
      final appState = context.read<AppState>();
      final cityId = appState.selectedCity?.id ?? "hannover";
      final lang = appState.locale.languageCode;
      final sessionId = appState.sessionId;
      try {
        final uri = Uri.parse("$_apiBaseUrl/feedback");
        await http.post(
          uri,
          headers: const {"Content-Type": "application/json"},
          body: json.encode({
            "city": cityId,
            "item_id": itemId,
            "feedback": value,
            "lang": lang,
            "source": "flutter",
            "session_id": sessionId,
          }),
        );
      } catch (_) {
        return;
      }
  }

  Widget _buildNotFound(BuildContext context, AppLocalizations loc) {
    final colorScheme = Theme.of(context).colorScheme;
    final hintLines = _hintLinesForMode(loc, _result.searchMode);
    return ListView(
      padding: const EdgeInsets.only(bottom: _notFoundBarHeight + 16),
      children: [
        _buildEmptyStateBadge(),
        const SizedBox(height: DesignTokens.baseSpacing),
        Text(
          loc.t("no_match_title"),
          style: DesignTokens.titleL.copyWith(color: colorScheme.onSurface),
        ),
        const SizedBox(height: 6),
        Text(
          loc.t("no_match_subtitle"),
          style: DesignTokens.body.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: DesignTokens.baseSpacing),
        _buildHintCard(loc, hintLines),
        const SizedBox(height: DesignTokens.sectionSpacing),
        SectionTitle(title: loc.t("similar_suggestions")),
        const SizedBox(height: DesignTokens.baseSpacing),
        ..._result.similarItems.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: DesignTokens.baseSpacing),
            child: SimilarItemCard(
              item: item,
              onTap: () => _resolveSimilarItem(item),
            ),
          ),
        ),
      ],
    );
  }

  List<String> _hintLinesForMode(AppLocalizations loc, SearchMode mode) {
    switch (mode) {
      case SearchMode.text:
        return [loc.t("hint_text_mode_text")];
      case SearchMode.image:
        return [loc.t("hint_text_mode_image")];
      case SearchMode.unknown:
        return [
          loc.t("hint_text_mode_unknown_1"),
          loc.t("hint_text_mode_unknown_2"),
        ];
    }
  }

  Widget _buildHintCard(AppLocalizations loc, List<String> lines) {
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
          ...lines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                line,
                style: DesignTokens.body.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStateBadge() {
    final colorScheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(DesignTokens.cornerRadius),
        ),
        child: Icon(
          Icons.search_off_outlined,
          size: 30,
          color: colorScheme.primary,
        ),
      ),
    );
  }
}

class _LeadingIconBadge extends StatelessWidget {
  const _LeadingIconBadge({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: colorScheme.primary, size: 20),
    );
  }
}



