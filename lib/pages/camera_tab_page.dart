import "dart:convert";
import "dart:math";
import "dart:typed_data";
import "dart:ui" as ui;

import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:image_picker/image_picker.dart";
import "package:provider/provider.dart";
import "package:image/image.dart" as img;

import "../config/api_config.dart";
import "../l10n/app_localizations.dart";
import "../models/scan_result.dart";
import "../models/similar_item.dart";
import "../models/warning.dart";
import "../services/presigned_upload_service.dart";
import "../state/app_state.dart";
import "result_page.dart";
import "city_picker_page.dart";

class CameraTabPage extends StatefulWidget {
  const CameraTabPage({super.key});

  @override
  CameraTabPageState createState() => CameraTabPageState();
}

class CameraTabPageState extends State<CameraTabPage> {
  Uint8List? _imageBytes;
  bool _isLoading = false;
  bool _isPicking = false;
  bool _isScanning = false;
  bool _isActive = false;

  void handleTabSelected() {}

  void setActive(bool active) {
    if (_isActive == active) {
      return;
    }
    _isActive = active;
    if (!active) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      openCamera(force: true);
    });
  }

  void resetForCityChange() {
    if (!mounted) {
      return;
    }
    setState(() {
      _imageBytes = null;
      _isLoading = false;
      _isPicking = false;
      _isScanning = false;
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

  Future<void> openCamera({bool force = false}) async {
    if (_isPicking || _isLoading || _isScanning) {
      return;
    }
    await _pickImage();
  }

  Future<void> openGallery() async {
    if (_isPicking || _isLoading || _isScanning) {
      return;
    }
    await _pickImageInternal(source: ImageSource.gallery);
  }

  Future<void> _pickImage() async {
    await _pickImageInternal(source: ImageSource.camera);
  }

  void _queueReopenCamera() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_isActive) {
        return;
      }
      openCamera(force: true);
    });
  }

  Future<void> _pickImageInternal({
    required ImageSource source,
  }) async {
    if (_isPicking) {
      return;
    }
    _isPicking = true;
    _isScanning = true;
    try {
      final picker = ImagePicker();
      final file = source == ImageSource.camera
          ? await picker.pickImage(
              source: source,
              preferredCameraDevice: CameraDevice.rear,
            )
          : await picker.pickImage(source: source);
      if (file == null) {
        return;
      }
      final bytes = await file.readAsBytes();
      final cropped = _cropToFocus(bytes);
      setState(() {
        _imageBytes = cropped;
      });
      await _runAnalyze();
    } finally {
      _isPicking = false;
      _isScanning = false;
    }
  }

  Uint8List _cropToFocus(Uint8List bytes) {
    try {
      final decoded = img.decodeImage(bytes);
      if (decoded == null) {
        return bytes;
      }
      final size = min(decoded.width, decoded.height);
      final cropSize = (size * 0.6).round();
      final x = ((decoded.width - cropSize) / 2).round();
      final y = ((decoded.height - cropSize) / 2).round();
      final cropped = img.copyCrop(
        decoded,
        x: x,
        y: y,
        width: cropSize,
        height: cropSize,
      );
      return Uint8List.fromList(img.encodeJpg(cropped, quality: 88));
    } catch (_) {
      return bytes;
    }
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
            disposalCodes: item.disposalCodes,
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

  Future<void> _runAnalyze() async {
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
    if (_imageBytes == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final contentType =
          PresignedUploadService.detectContentType(_imageBytes!);
      debugPrint(
          "analyze(image): content_type=$contentType bytes=${_imageBytes!.length}");
      final presign = await PresignedUploadService.presign(
        appState: appState,
        contentType: contentType,
      );
      await PresignedUploadService.upload(
        presign: presign,
        bytes: _imageBytes!,
      );

      final uri = Uri.parse("${ApiConfig.baseUrl}/analyze");
      debugPrint("analyze(image): calling /analyze s3_key=${presign.s3Key}");
      final headers = await appState.authHeaders(
        extra: const {"Content-Type": "application/json"},
      );
      final response = await http.post(
        uri,
        headers: headers,
        body: json.encode({
          "city": city.id,
          "lang": appState.locale.languageCode,
          "s3_key": presign.s3Key,
        }),
      );
      final statusOk = response.statusCode >= 200 && response.statusCode < 300;
      final body = json.decode(response.body) as Map<String, dynamic>;

      final item = body["item"];
      final suggestions = (body["suggestions"] as List<dynamic>?) ?? [];
      final recycle = body["recycle"] as Map<String, dynamic>? ?? {};
      final disposals = (recycle["disposals"] as List<dynamic>?) ?? [];
      final noCityRules =
          item != null && disposals.isEmpty && suggestions.isNotEmpty;
      final notFound =
          item == null || body["error"] == "item_not_found" || noCityRules;
      if (notFound && !statusOk) {
        throw Exception("Analyze failed");
      }
      if (!mounted) {
        return;
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
            Warning(
                severity: WarningSeverity.warn, messageKey: "no_match_message"),
          ],
          similarItems: _localizeSimilarItems(similar, loc),
          imageBytes: _imageBytes,
          imageUrl: null,
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
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ResultPage(result: result)),
        );
        if (mounted) {
          setState(() {
            _imageBytes = null;
          });
          _queueReopenCamera();
        }
        return;
      }

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
        disposalCodes: _codesFromList(body["disposals"] ?? disposals),
        bestOption: null,
        otherOptions: const [],
        warnings: warnings,
        similarItems: const [],
        imageBytes: _imageBytes,
        imageUrl: item["image_url"]?.toString(),
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
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ResultPage(result: result)),
      );
      if (mounted) {
        setState(() {
          _imageBytes = null;
        });
        _queueReopenCamera();
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
      });
      _showConnectionError();
    }
  }

  List<SimilarItem> _similarityFromApi(
      Map<String, dynamic> body, String cityId) {
    final suggestions = (body["suggestions"] as List<dynamic>?) ?? [];
    if (suggestions.isEmpty) {
      return const [];
    }
    return suggestions.take(3).map((entry) {
      if (entry is Map<String, dynamic>) {
        final name = _pickDisplayName(entry);
        final alias = _pickAliasName(entry);
        final disposals =
            _labelsFromList(entry["disposals"] ?? entry["disposal_labels"]);
        final disposalCodes =
            _codesFromList(entry["disposals"] ?? entry["disposal_codes"]);
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

  List<String> _labelsFromList(dynamic rawList) {
    final list = (rawList as List<dynamic>?) ?? [];
    return list
        .map((entry) {
          if (entry is Map<String, dynamic>) {
            final nestedCategory = entry["category"];
            if (nestedCategory is Map<String, dynamic>) {
              return (nestedCategory["label"] ??
                      nestedCategory["name"] ??
                      nestedCategory["title"] ??
                      nestedCategory["code"] ??
                      "")
                  .toString();
            }
            return (entry["label"] ??
                    entry["name"] ??
                    entry["title"] ??
                    entry["category_label"] ??
                    entry["code"] ??
                    "")
                .toString();
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

  Widget _buildBusyBackground(ColorScheme colorScheme, bool showProcessing) {
    if (!showProcessing || _imageBytes == null) {
      return DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              colorScheme.surfaceContainerLowest.withValues(alpha: 0.22),
            ],
          ),
        ),
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        Transform.scale(
          scale: 1.06,
          child: ImageFiltered(
            imageFilter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Image.memory(
              _imageBytes!,
              fit: BoxFit.cover,
              gaplessPlayback: true,
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.18),
                Colors.black.withValues(alpha: 0.48),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBusyCard(
    AppLocalizations loc,
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool showProcessing,
  ) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        decoration: BoxDecoration(
          color: colorScheme.surface.withValues(alpha: 0.88),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colorScheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.24),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (showProcessing && _imageBytes != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(
                      _imageBytes!,
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.t("camera_processing_title"),
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        loc.t("camera_processing_subtitle"),
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.6,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: const LinearProgressIndicator(minHeight: 5),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final busy = _isLoading || _isPicking || _isScanning;
    final showProcessing = _isLoading && _imageBytes != null;

    return ColoredBox(
      color: Colors.black,
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              child: _buildBusyBackground(colorScheme, showProcessing),
            ),
          ),
          if (busy)
            Center(
              child: _buildBusyCard(
                loc,
                colorScheme,
                textTheme,
                showProcessing,
              ),
            ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: SafeArea(
              top: false,
              child: OutlinedButton.icon(
                onPressed: busy ? null : openGallery,
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(loc.t("scan_pick_gallery")),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.55)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
