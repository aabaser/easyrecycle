import "dart:typed_data";

import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../l10n/app_localizations.dart";
import "../models/admin_item.dart";
import "../models/admin_image.dart";
import "../services/admin_service.dart";
import "../state/app_state.dart";
import "../theme/design_tokens.dart";
import "../widgets/primary_button.dart";
import "../widgets/max_width_center.dart";

class AdminItemDetailPage extends StatefulWidget {
  const AdminItemDetailPage({super.key, required this.itemId});

  final String itemId;

  @override
  State<AdminItemDetailPage> createState() => _AdminItemDetailPageState();
}

class _AdminItemDetailPageState extends State<AdminItemDetailPage> {
  final _service = AdminService();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _categoryController = TextEditingController();
  final _disposalController = TextEditingController();
  final _warningController = TextEditingController();

  AdminItemDetail? _detail;
  List<AdminImageAsset> _itemImages = [];
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
    _descController.dispose();
    _categoryController.dispose();
    _disposalController.dispose();
    _warningController.dispose();
    super.dispose();
  }

  List<String> _parseCodes(String value) {
    return value
        .split(",")
        .map((entry) => entry.trim())
        .where((entry) => entry.isNotEmpty)
        .toList();
  }

  Future<void> _loadDetail() async {
    final appState = context.read<AppState>();
    final cityId = appState.selectedCity?.id;
    if (cityId == null) {
      return;
    }
    setState(() {
      _loading = true;
    });
    try {
      final detail = await _service.getItem(
        itemId: widget.itemId,
        cityId: cityId,
        lang: appState.locale.languageCode,
      );
      final images = await _service.listItemImages(widget.itemId);
      if (!mounted) {
        return;
      }
      _titleController.text = detail.item.title ?? "";
      _descController.text = detail.item.description ?? "";
      _categoryController.text =
          detail.categories.map((c) => c.code).join(", ");
      _disposalController.text =
          detail.disposals.map((d) => d.code).join(", ");
      _warningController.text = detail.warnings.map((w) => w.code).join(", ");
      setState(() {
        _detail = detail;
        _itemImages = images;
        _selectedImageId = detail.item.primaryImageId ??
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
        _isActive = detail.item.isActive;
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
    final cityId = appState.selectedCity?.id;
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
        description: _descController.text.trim(),
        categoryCodes: _parseCodes(_categoryController.text),
        disposalCodes: _parseCodes(_disposalController.text),
        warningCodes: _parseCodes(_warningController.text),
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
    final cityId = appState.selectedCity?.id;
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
    final cityId = appState.selectedCity?.id;
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
        : "${AdminService.baseUrl}${image.imageUrl}";
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
    final appState = context.watch<AppState>();
    final city = appState.selectedCity;

    if (city == null) {
      return Scaffold(
        appBar: AppBar(title: Text(loc.t("admin_title"))),
        body: Center(child: Text(loc.t("admin_city_required"))),
      );
    }

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
                        TextField(
                          controller: _descController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText: loc.t("admin_description_label"),
                          ),
                        ),
                        const SizedBox(height: DesignTokens.sectionSpacing),
                        Text(loc.t("admin_category_label"), style: DesignTokens.titleM),
                        const SizedBox(height: DesignTokens.baseSpacing),
                        TextField(
                          controller: _categoryController,
                          decoration: InputDecoration(
                            hintText: loc.t("admin_category_hint"),
                          ),
                        ),
                        const SizedBox(height: DesignTokens.sectionSpacing),
                        Text(loc.t("admin_disposal_label"), style: DesignTokens.titleM),
                        const SizedBox(height: DesignTokens.baseSpacing),
                        TextField(
                          controller: _disposalController,
                          decoration: InputDecoration(
                            hintText: loc.t("admin_disposal_hint"),
                          ),
                        ),
                        const SizedBox(height: DesignTokens.sectionSpacing),
                        Text(loc.t("admin_warning_label"), style: DesignTokens.titleM),
                        const SizedBox(height: DesignTokens.baseSpacing),
                        TextField(
                          controller: _warningController,
                          decoration: InputDecoration(
                            hintText: loc.t("admin_warning_hint"),
                          ),
                        ),
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
                          label: _saving
                              ? loc.t("admin_saving")
                              : loc.t("admin_save"),
                          onPressed: _saving ? null : _saveChanges,
                        ),
                      ],
                    )),
        ),
      ),
    );
  }
}
