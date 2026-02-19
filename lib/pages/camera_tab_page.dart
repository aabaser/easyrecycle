import "dart:convert";
import "dart:math";

import "package:file_picker/file_picker.dart";
import "package:flutter/foundation.dart";
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
import "../services/mock_similarity_service.dart";
import "../services/presigned_upload_service.dart";
import "../state/app_state.dart";
import "../ui/components/er_button.dart";
import "result_page.dart";
import "city_picker_page.dart";

class CameraTabPage extends StatefulWidget {
  const CameraTabPage({super.key});

  @override
  CameraTabPageState createState() => CameraTabPageState();
}

class CameraTabPageState extends State<CameraTabPage> {
  final _similarityService = MockSimilarityService();
  Uint8List? _imageBytes;
  bool _isLoading = false;
  bool _isPicking = false;
  bool _isScanning = false;

  void handleTabSelected() {}

  void setActive(bool active) {}

  Future<void> openCamera({bool force = false}) async {
    if (_isPicking || _isLoading || _isScanning) {
      return;
    }
    await _pickImage();
  }

  Future<void> _pickImage() async {
    await _pickImageInternal(source: ImageSource.camera);
  }

  Future<void> _pickGallery() async {
    await _pickImageInternal(
      source: ImageSource.gallery,
      useFilePicker: kIsWeb,
    );
  }

  Future<void> _pickImageInternal({
    required ImageSource source,
    bool useFilePicker = false,
  }) async {
    if (_isPicking) {
      return;
    }
    _isPicking = true;
    _isScanning = true;
    try {
      if (useFilePicker) {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          withData: true,
        );
        final bytes = result?.files.single.bytes;
        if (bytes == null) {
          return;
        }
        final cropped = _cropToFocus(bytes);
        setState(() {
          _imageBytes = cropped;
        });
        await _runAnalyze();
        return;
      }

      final picker = ImagePicker();
      final file = await picker.pickImage(source: source);
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
        .replaceAll(RegExp(r"<br\\s*/?>", caseSensitive: false), "\n")
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
    text = text.replaceAll(RegExp(r"\\s+"), " ").trim();
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
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<SimilarItem> _similarityFromApi(
      Map<String, dynamic> body, String cityId) {
    final suggestions = (body["suggestions"] as List<dynamic>?) ?? [];
    if (suggestions.isEmpty) {
      return _similarityService.getTop3Similar(
        cityId: cityId,
        queryText: null,
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

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ColoredBox(color: colorScheme.surfaceContainerHigh),
                  Opacity(
                    opacity: 0.92,
                    child: Image.asset(
                      "assets/uix/header.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.08),
                          Colors.black.withValues(alpha: 0.25),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 86,
                      height: 86,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLowest
                            .withValues(alpha: 0.88),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.camera_alt_outlined,
                        size: 42,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 14,
                    child: Text(
                      loc.t("scan_focus_hint"),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ERButton(
            label: loc.t("scan_take_photo"),
            loading: _isLoading,
            onPressed: _isLoading || _isScanning ? null : _pickImage,
          ),
          const SizedBox(height: 10),
          ERButton(
            label: loc.t("scan_pick_gallery"),
            variant: ERButtonVariant.secondary,
            onPressed: _isLoading || _isScanning ? null : _pickGallery,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
