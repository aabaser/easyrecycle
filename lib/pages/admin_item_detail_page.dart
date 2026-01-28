import "dart:typed_data";

import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../config/api_config.dart";
import "../l10n/app_localizations.dart";
import "../models/admin_item.dart";
import "../models/admin_image.dart";
import "../models/city.dart";
import "../services/admin_service.dart";
import "../state/app_state.dart";
import "../theme/design_tokens.dart";
import "../widgets/app_bottom_nav.dart";
import "../widgets/primary_button.dart";
import "../widgets/max_width_center.dart";
import "home_shell.dart";

class AdminItemDetailPage extends StatefulWidget {
  const AdminItemDetailPage({super.key, required this.itemId});

  final String itemId;

  @override
  State<AdminItemDetailPage> createState() => _AdminItemDetailPageState();
}

class _AdminItemDetailPageState extends State<AdminItemDetailPage> {
  final _service = AdminService();
  final _titleController = TextEditingController();
  final Map<String, TextEditingController> _descControllers = {};
  final ScrollController _tableScrollController = ScrollController();

  AdminItemDetail? _detail;
  List<AdminImageAsset> _itemImages = [];
  final Map<String, AdminOptions> _optionsByCity = {};
  List<City> _cities = [];
  List<String> _selectedCategoryCodes = [];
  List<String> _selectedDisposalCodes = [];
  List<String> _selectedWarningCodes = [];
  final Map<String, List<String>> _categoryCodesByCity = {};
  final Map<String, List<String>> _disposalCodesByCity = {};
  final Map<String, List<String>> _warningCodesByCity = {};
  final Map<String, bool> _savingByCity = {};
  bool _loading = true;
  bool _saving = false;
  String? _selectedImageId;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _tableScrollController.dispose();
    for (final controller in _descControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String _formatSelectedLabels(
    List<String> codes,
    List<AdminCodeLabel> options,
    String fallback,
  ) {
    if (codes.isEmpty) {
      return fallback;
    }
    final labelMap = {for (final opt in options) opt.code: opt.label ?? opt.code};
    return codes.map((code) => labelMap[code] ?? code).join(", ");
  }

  String _previewText(String? value, {int maxLength = 120}) {
    if (value == null || value.trim().isEmpty) {
      return "-";
    }
    final text = value.trim();
    if (text.length <= maxLength) {
      return text;
    }
    return "${text.substring(0, maxLength)}…";
  }

  Future<void> _pickCodes({
    required String title,
    required List<AdminCodeLabel> options,
    required List<String> selected,
    required void Function(List<String>) onSelected,
  }) async {
    final selectedSet = {...selected};
    final result = await showModalBottomSheet<List<String>>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(DesignTokens.baseSpacing),
                    child: Text(title, style: DesignTokens.titleM),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView.builder(
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options[index];
                        final isSelected = selectedSet.contains(option.code);
                        return CheckboxListTile(
                          value: isSelected,
                          title: Text(option.label ?? option.code),
                          onChanged: (value) {
                            setSheetState(() {
                              if (value == true) {
                                selectedSet.add(option.code);
                              } else {
                                selectedSet.remove(option.code);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(DesignTokens.baseSpacing),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(selectedSet.toList()),
                        child: Text(AppLocalizations.of(context).t("info_ok")),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    if (result != null) {
      onSelected(result);
    }
  }

  Future<void> _openCityEditor(City city) async {
    final options = _optionsByCity[city.id];
    final descController = _descControllers[city.id];
    if (options == null || descController == null) {
      return;
    }
    final loc = AppLocalizations.of(context);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final categoryCodes = _categoryCodesByCity[city.id] ?? [];
            final disposalCodes = _disposalCodesByCity[city.id] ?? [];
            final warningCodes = _warningCodesByCity[city.id] ?? [];
            final savingCity = _savingByCity[city.id] ?? false;
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: DesignTokens.sectionSpacing,
                  right: DesignTokens.sectionSpacing,
                  top: DesignTokens.baseSpacing,
                  bottom: MediaQuery.of(context).viewInsets.bottom +
                      DesignTokens.sectionSpacing,
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Text(city.name, style: DesignTokens.titleM),
                    const SizedBox(height: DesignTokens.baseSpacing),
                    TextField(
                      controller: descController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: loc.t("admin_description_label"),
                      ),
                    ),
                    const SizedBox(height: DesignTokens.sectionSpacing),
                    Text(loc.t("admin_category_label"), style: DesignTokens.titleM),
                    const SizedBox(height: DesignTokens.baseSpacing),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        _formatSelectedLabels(
                          categoryCodes,
                          options.categories,
                          loc.t("admin_category_hint"),
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        await _pickCodes(
                          title: loc.t("admin_category_label"),
                          options: options.categories,
                          selected: categoryCodes,
                          onSelected: (value) {
                            setState(() {
                              _categoryCodesByCity[city.id] = value;
                            });
                          },
                        );
                        setSheetState(() {});
                      },
                    ),
                    const SizedBox(height: DesignTokens.sectionSpacing),
                    Text(loc.t("admin_disposal_label"), style: DesignTokens.titleM),
                    const SizedBox(height: DesignTokens.baseSpacing),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        _formatSelectedLabels(
                          disposalCodes,
                          options.disposals,
                          loc.t("admin_disposal_hint"),
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        await _pickCodes(
                          title: loc.t("admin_disposal_label"),
                          options: options.disposals,
                          selected: disposalCodes,
                          onSelected: (value) {
                            setState(() {
                              _disposalCodesByCity[city.id] = value;
                            });
                          },
                        );
                        setSheetState(() {});
                      },
                    ),
                    const SizedBox(height: DesignTokens.sectionSpacing),
                    Text(loc.t("admin_warning_label"), style: DesignTokens.titleM),
                    const SizedBox(height: DesignTokens.baseSpacing),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        _formatSelectedLabels(
                          warningCodes,
                          options.warnings,
                          loc.t("admin_warning_hint"),
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        await _pickCodes(
                          title: loc.t("admin_warning_label"),
                          options: options.warnings,
                          selected: warningCodes,
                          onSelected: (value) {
                            setState(() {
                              _warningCodesByCity[city.id] = value;
                            });
                          },
                        );
                        setSheetState(() {});
                      },
                    ),
                    const SizedBox(height: DesignTokens.sectionSpacing),
                    PrimaryButton(
                      label: savingCity
                          ? loc.t("admin_saving")
                          : loc.t("admin_save"),
                      onPressed: savingCity
                          ? null
                          : () async {
                              await _saveCity(city.id);
                              if (mounted) {
                                Navigator.of(context).pop();
                              }
                            },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _loadDetail() async {
    final appState = context.read<AppState>();
    setState(() {
      _loading = true;
    });
    try {
      final lang = appState.locale.languageCode;
      final citiesFuture = _service.listCities(lang: lang);
      final imagesFuture = _service.listItemImages(widget.itemId);
      final results = await Future.wait([citiesFuture, imagesFuture]);
      final cities = results[0] as List<City>;
      final images = results[1] as List<AdminImageAsset>;
      final optionsList = await Future.wait(
        cities.map((city) async {
          try {
            return await _service.getOptions(
              lang: lang,
              cityId: city.id,
            );
          } catch (_) {
            return const AdminOptions(categories: [], disposals: [], warnings: []);
          }
        }),
      );
      final optionsByCity = <String, AdminOptions>{};
      for (var i = 0; i < cities.length; i++) {
        optionsByCity[cities[i].id] = optionsList[i];
      }
      final detailFutures = cities
          .map(
            (city) => _service.getItem(
              itemId: widget.itemId,
              cityId: city.id,
              lang: lang,
            ),
          )
          .toList();
      final details = await Future.wait(detailFutures);
      final firstDetail = details.isNotEmpty ? details.first : null;
      if (!mounted) {
        return;
      }
      setState(() {
        _detail = firstDetail;
        _itemImages = images;
        _optionsByCity
          ..clear()
          ..addAll(optionsByCity);
        _cities = cities;
        _selectedCategoryCodes = firstDetail?.categories.map((c) => c.code).toList() ?? [];
        _selectedDisposalCodes = firstDetail?.disposals.map((d) => d.code).toList() ?? [];
        _selectedWarningCodes = firstDetail?.warnings.map((w) => w.code).toList() ?? [];
        _selectedImageId = firstDetail?.item.primaryImageId ??
            images.firstWhere(
              (img) => img.isPrimary,
              orElse: () => images.isNotEmpty
                  ? images.first
                  : const AdminImageAsset(
                      imageId: "",
                      imageUrl: "",
                      width: null,
                      height: null,
                      source: null,
                      createdAt: null,
                      isPrimary: false,
                    ),
        ).imageId;
        if (_selectedImageId != null && _selectedImageId!.isEmpty) {
          _selectedImageId = null;
        }
        _isActive = firstDetail?.item.isActive ?? true;
        for (var i = 0; i < cities.length; i++) {
          final city = cities[i];
          final detail = details[i];
          _descControllers[city.id]?.dispose();
          _descControllers[city.id] =
              TextEditingController(text: detail.item.description ?? "");
          _categoryCodesByCity[city.id] =
              detail.categories.map((c) => c.code).toList();
          _disposalCodesByCity[city.id] =
              detail.disposals.map((d) => d.code).toList();
          _warningCodesByCity[city.id] =
              detail.warnings.map((w) => w.code).toList();
        }
        if (firstDetail != null) {
          _titleController.text = firstDetail.item.title ?? "";
        }
        _loading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _detail = null;
        _itemImages = [];
        _loading = false;
      });
    }
  }

  Future<void> _saveChanges() async {
    final detail = _detail;
    if (detail == null) {
      return;
    }
    final appState = context.read<AppState>();
    final cityId =
        _cities.isNotEmpty ? _cities.first.id : appState.selectedCity?.id;
    if (cityId == null) {
      return;
    }
    setState(() {
      _saving = true;
    });
    try {
      final updated = await _service.updateItem(
        itemId: detail.item.id,
        cityId: cityId,
        lang: appState.locale.languageCode,
        title: _titleController.text.trim(),
        primaryImageId: _selectedImageId,
        isActive: _isActive,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _detail = updated;
        _saving = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _saving = false;
      });
    }
  }

  Future<void> _saveCity(String cityId) async {
    final detail = _detail;
    if (detail == null) {
      return;
    }
    final appState = context.read<AppState>();
    final controller = _descControllers[cityId];
    if (controller == null) {
      return;
    }
    setState(() {
      _savingByCity[cityId] = true;
    });
    try {
      final updated = await _service.updateItem(
        itemId: detail.item.id,
        cityId: cityId,
        lang: appState.locale.languageCode,
        description: controller.text.trim(),
        categoryCodes: _categoryCodesByCity[cityId] ?? [],
        disposalCodes: _disposalCodesByCity[cityId] ?? [],
        warningCodes: _warningCodesByCity[cityId] ?? [],
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _categoryCodesByCity[cityId] =
            updated.categories.map((c) => c.code).toList();
        _disposalCodesByCity[cityId] =
            updated.disposals.map((d) => d.code).toList();
        _warningCodesByCity[cityId] =
            updated.warnings.map((w) => w.code).toList();
        controller.text = updated.item.description ?? "";
      });
    } catch (_) {} finally {
      if (!mounted) {
        return;
      }
      setState(() {
        _savingByCity[cityId] = false;
      });
    }
  }

  Future<void> _uploadImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    final bytes = result?.files.single.bytes;
    if (bytes == null) {
      return;
    }
    await _uploadImageBytes(bytes);
  }

  Future<void> _uploadImageBytes(Uint8List bytes) async {
    final appState = context.read<AppState>();
    final cityId =
        _cities.isNotEmpty ? _cities.first.id : appState.selectedCity?.id;
    if (cityId == null) {
      return;
    }
    try {
      final uploaded = await _service.uploadItemImage(
        itemId: widget.itemId,
        cityId: cityId,
        bytes: bytes,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _itemImages = [uploaded, ..._itemImages];
      });
      if (_selectedImageId == null) {
        await _setPrimaryImage(uploaded.imageId);
      }
    } catch (_) {}
  }

  Future<void> _setPrimaryImage(String imageId) async {
    final detail = _detail;
    if (detail == null) {
      return;
    }
    final appState = context.read<AppState>();
    final cityId =
        _cities.isNotEmpty ? _cities.first.id : appState.selectedCity?.id;
    if (cityId == null) {
      return;
    }
    setState(() {
      _selectedImageId = imageId;
    });
    try {
      final updated = await _service.updateItem(
        itemId: detail.item.id,
        cityId: cityId,
        lang: appState.locale.languageCode,
        primaryImageId: imageId,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _detail = updated;
      });
    } catch (_) {}
  }

  Future<void> _deleteSelectedImage() async {
    final imageId = _selectedImageId;
    if (imageId == null) {
      return;
    }
    try {
      await _service.deleteItemImage(
        itemId: widget.itemId,
        imageId: imageId,
      );
      if (!mounted) {
        return;
      }
      final images = await _service.listItemImages(widget.itemId);
      if (!mounted) {
        return;
      }
      setState(() {
        _itemImages = images;
        _selectedImageId = images.firstWhere(
          (img) => img.isPrimary,
          orElse: () => images.isNotEmpty ? images.first : const AdminImageAsset(
            imageId: "",
            imageUrl: "",
            width: null,
            height: null,
            source: null,
            createdAt: null,
            isPrimary: false,
          ),
        ).imageId;
        if (_selectedImageId != null && _selectedImageId!.isEmpty) {
          _selectedImageId = null;
        }
      });
    } catch (_) {}
  }

  Widget _buildImageTile(AdminImageAsset image) {
    final isSelected = image.imageId == _selectedImageId;
    final resolvedUrl = image.imageUrl.startsWith("http")
        ? image.imageUrl
        : "${ApiConfig.baseUrl}${image.imageUrl}";
    return GestureDetector(
      onTap: () => _setPrimaryImage(image.imageId),
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(resolvedUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.t("admin_item_details"), style: DesignTokens.titleM),
      ),
      body: MaxWidthCenter(
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.sectionSpacing),
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : (_detail == null
                  ? Center(child: Text(loc.t("admin_item_not_found")))
                      : ListView(
                      children: [
                        Text(
                          _detail!.item.canonicalKey,
                          style: DesignTokens.caption.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: DesignTokens.baseSpacing),
                        TextField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: loc.t("admin_title_label"),
                          ),
                        ),
                        const SizedBox(height: DesignTokens.baseSpacing),
                        const SizedBox(height: DesignTokens.sectionSpacing),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(loc.t("admin_active_label")),
                          value: _isActive,
                          onChanged: (value) {
                            setState(() {
                              _isActive = value;
                            });
                          },
                        ),
                        const SizedBox(height: DesignTokens.sectionSpacing),
                        Text(loc.t("admin_images_title"), style: DesignTokens.titleM),
                        const SizedBox(height: DesignTokens.baseSpacing),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: _uploadImage,
                            icon: const Icon(Icons.upload_outlined),
                            label: Text(loc.t("admin_upload_image")),
                          ),
                        ),
                        if (_selectedImageId != null)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: _deleteSelectedImage,
                              icon: const Icon(Icons.delete_outline),
                              label: Text(loc.t("admin_remove_image")),
                            ),
                          ),
                        const SizedBox(height: DesignTokens.baseSpacing),
                        if (_itemImages.isNotEmpty)
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: _itemImages.map(_buildImageTile).toList(),
                          ),
                        const SizedBox(height: DesignTokens.sectionSpacing),
                        PrimaryButton(
                          label: _saving ? loc.t("admin_saving") : loc.t("admin_save"),
                          onPressed: _saving ? null : _saveChanges,
                        ),
                        const SizedBox(height: DesignTokens.sectionSpacing),
                        Text(loc.t("admin_city_settings"), style: DesignTokens.titleM),
                        const SizedBox(height: DesignTokens.baseSpacing),
                        if (_cities.isEmpty)
                          Text(loc.t("admin_no_cities")),
                        if (_cities.isNotEmpty)
                          Scrollbar(
                            controller: _tableScrollController,
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              controller: _tableScrollController,
                              scrollDirection: Axis.horizontal,
                              child: SizedBox(
                                width: 980,
                                child: DataTable(
                                  columnSpacing: 24,
                                  columns: [
                                    DataColumn(label: Text(loc.t("admin_city_label"))),
                                    DataColumn(label: Text(loc.t("admin_category_label"))),
                                    DataColumn(label: Text(loc.t("admin_disposal_label"))),
                                    DataColumn(label: Text(loc.t("admin_warning_label"))),
                                    DataColumn(label: Text(loc.t("admin_description_label"))),
                                    DataColumn(label: Text(loc.t("admin_actions"))),
                                  ],
                                  rows: _cities.map((city) {
                                    final options = _optionsByCity[city.id];
                                    final descController = _descControllers[city.id];
                                    if (options == null || descController == null) {
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(city.name)),
                                          const DataCell(Text("-")),
                                          const DataCell(Text("-")),
                                          const DataCell(Text("-")),
                                          const DataCell(Text("-")),
                                          const DataCell(SizedBox.shrink()),
                                        ],
                                      );
                                    }
                                    final categoryCodes = _categoryCodesByCity[city.id] ?? [];
                                    final disposalCodes = _disposalCodesByCity[city.id] ?? [];
                                    final warningCodes = _warningCodesByCity[city.id] ?? [];
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(city.name)),
                                        DataCell(
                                          Text(
                                            _formatSelectedLabels(
                                              categoryCodes,
                                              options.categories,
                                              "-",
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            _formatSelectedLabels(
                                              disposalCodes,
                                              options.disposals,
                                              "-",
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            _formatSelectedLabels(
                                              warningCodes,
                                              options.warnings,
                                              "-",
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          ConstrainedBox(
                                            constraints: const BoxConstraints(maxWidth: 280),
                                            child: Text(
                                              _previewText(descController.text),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          TextButton(
                                            onPressed: () => _openCityEditor(city),
                                            child: Text(loc.t("admin_edit")),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    )),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(
        selectedIndex: HomeShell.tabSettings,
      ),
    );
  }
}
