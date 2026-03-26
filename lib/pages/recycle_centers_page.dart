import "dart:async";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:geolocator/geolocator.dart";
import "package:provider/provider.dart";
import "package:url_launcher/url_launcher.dart";

import "../l10n/app_localizations.dart";
import "../models/recycle_center.dart";
import "../services/recycle_center_service.dart";
import "../state/app_state.dart";
import "../theme/design_tokens.dart";
import "../widgets/max_width_center.dart";

class RecycleCentersPage extends StatefulWidget {
  const RecycleCentersPage({
    super.key,
    this.cityCode,
    this.initialTypeCode,
    this.initialDisposalPositive,
    this.showAppBar = true,
  });

  final String? cityCode;
  final int? initialTypeCode;
  final String? initialDisposalPositive;
  final bool showAppBar;

  @override
  State<RecycleCentersPage> createState() => _RecycleCentersPageState();
}

class _RecycleCentersPageState extends State<RecycleCentersPage> {
  static const String _otherTypeValue = "__other__";

  bool _loading = true;
  String? _error;
  bool _locationDenied = false;
  List<RecycleCenter> _centers = [];
  String _cityCode = "hannover";
  int? _selectedTypeCode;
  String? _selectedTypeLabel;
  Set<String> _selectedDisposalPositives = <String>{};
  AppState? _appState;
  int _openedCityVersion = 0;
  bool _closingForCityChange = false;
  int _loadToken = 0;

  @override
  void initState() {
    super.initState();
    _appState = context.read<AppState>();
    _openedCityVersion = _appState!.citySelectionVersion;
    _selectedTypeCode = widget.initialTypeCode;
    if (widget.initialDisposalPositive != null &&
        widget.initialDisposalPositive!.trim().isNotEmpty) {
      _selectedDisposalPositives = {widget.initialDisposalPositive!.trim()};
    }
    _appState!.addListener(_handleAppStateChanged);
    _load();
  }

  @override
  void dispose() {
    _appState?.removeListener(_handleAppStateChanged);
    super.dispose();
  }

  void _handleAppStateChanged() {
    final appState = _appState;
    if (!mounted || appState == null || _closingForCityChange) {
      return;
    }
    if (appState.citySelectionVersion == _openedCityVersion) {
      final requestedFilter = appState.consumeRequestedRecycleCenterFilter();
      if (requestedFilter == null) {
        return;
      }
      _applyRequestedFilter(
        requestedFilter.cityCode,
        requestedFilter.typCode,
        requestedFilter.disposalPositive,
      );
      return;
    }
    _openedCityVersion = appState.citySelectionVersion;
    _closingForCityChange = true;

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).maybePop();
      _closingForCityChange = false;
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _locationDenied = false;
        _centers = [];
        _selectedTypeCode = null;
        _selectedTypeLabel = null;
        _selectedDisposalPositives = <String>{};
      });
    _closingForCityChange = false;
    _load();
  }

  void _applyRequestedFilter(
    String cityCode,
    int? typCode,
    String? disposalPositive,
  ) {
    setState(() {
      _cityCode = cityCode;
      _loading = true;
      _error = null;
      _locationDenied = false;
      _centers = [];
      _selectedTypeCode = typCode;
      _selectedTypeLabel = null;
      _selectedDisposalPositives = disposalPositive == null ||
              disposalPositive.trim().isEmpty
          ? <String>{}
          : {disposalPositive.trim()};
    });
    _load(
      cityCodeOverride: cityCode,
      typCodeOverride: typCode,
      disposalPositiveOverride: disposalPositive,
    );
  }

  Future<void> _load({
    String? cityCodeOverride,
    int? typCodeOverride,
    String? disposalPositiveOverride,
  }) async {
    final appState = context.read<AppState>();
    final cityCode =
        cityCodeOverride ?? widget.cityCode ?? appState.selectedCity?.id ?? "hannover";
    final typCode = typCodeOverride ?? _selectedTypeCode;
    final selectedDisposals = disposalPositiveOverride == null ||
            disposalPositiveOverride.trim().isEmpty
        ? Set<String>.from(_selectedDisposalPositives)
        : {disposalPositiveOverride.trim()};
    _cityCode = cityCode;
    final loadToken = ++_loadToken;

    try {
      final centers = await RecycleCenterService.fetchCenters(
        appState: appState,
        cityCode: cityCode,
      );
      if (!mounted || loadToken != _loadToken) {
        return;
      }
      final resolvedTypeLabel = _resolveSelectedTypeLabel(centers, typCode);
      setState(() {
        _centers = List<RecycleCenter>.from(centers);
        _locationDenied = kIsWeb;
        _error = null;
        _selectedTypeCode = typCode;
        _selectedTypeLabel = resolvedTypeLabel;
        _selectedDisposalPositives = selectedDisposals
            .where(_disposalOptionsFrom(_centers).contains)
            .toSet();
        if (_selectedTypeLabel != null &&
            !_typeLabelsFrom(_centers).contains(_selectedTypeLabel)) {
          _selectedTypeLabel = null;
        }
        _loading = false;
      });
      unawaited(
        _refreshWithLocation(
          loadToken,
          appState,
          cityCode,
          typCode,
          selectedDisposals,
        ),
      );
    } catch (_) {
      if (!mounted || loadToken != _loadToken) {
        return;
      }
      setState(() {
        _error = "load_failed";
        _loading = false;
      });
    }
  }

  Future<void> _refreshWithLocation(
    int loadToken,
    AppState appState,
    String cityCode,
    int? typCode,
    Set<String> selectedDisposals,
  ) async {
    final locationResult = await _resolvePosition();
    if (!mounted || loadToken != _loadToken) {
      return;
    }
    if (locationResult.position == null) {
      setState(() {
        _locationDenied = locationResult.denied;
      });
      return;
    }

    try {
      final centers = await RecycleCenterService.fetchCenters(
        appState: appState,
        cityCode: cityCode,
        lat: locationResult.position!.latitude,
        lng: locationResult.position!.longitude,
      );
      if (!mounted || loadToken != _loadToken) {
        return;
      }
      final normalized = List<RecycleCenter>.from(centers)
        ..sort((a, b) {
          final aDistance = a.distanceKm ?? double.infinity;
          final bDistance = b.distanceKm ?? double.infinity;
          return aDistance.compareTo(bDistance);
        });
      setState(() {
        _centers = normalized;
        _locationDenied = false;
        _selectedTypeCode = typCode;
        _selectedTypeLabel = _resolveSelectedTypeLabel(normalized, typCode);
        _selectedDisposalPositives =
            selectedDisposals.where(_disposalOptionsFrom(normalized).contains).toSet();
        if (_selectedTypeLabel != null &&
            !_typeLabelsFrom(_centers).contains(_selectedTypeLabel)) {
          _selectedTypeLabel = null;
        }
      });
    } catch (_) {
      if (!mounted || loadToken != _loadToken) {
        return;
      }
      setState(() {
        _locationDenied = locationResult.denied;
      });
    }
  }

  String? _resolveSelectedTypeLabel(List<RecycleCenter> centers, int? typCode) {
    if (typCode == null) {
      return _selectedTypeLabel;
    }
    for (final center in centers) {
      if (center.typCode != typCode) {
        continue;
      }
      final label = _normalizedTypeValue(center.typLabel ?? "");
      if (label.isNotEmpty) {
        return label;
      }
    }
    return _selectedTypeLabel;
  }

  Future<({Position? position, bool denied})> _resolvePosition() async {
    if (kIsWeb) {
      return (position: null, denied: true);
    }
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return (position: null, denied: true);
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return (position: null, denied: true);
      }

      final lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) {
        return (position: lastKnown, denied: false);
      }

      final current = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      ).timeout(const Duration(seconds: 3));
      return (position: current, denied: false);
    } catch (_) {
      return (position: null, denied: true);
    }
  }

  String _mapsCityLabel() {
    switch (_cityCode) {
      case "berlin":
        return "Berlin";
      case "hannover":
        return "Hannover";
      default:
        return _cityCode;
    }
  }

  Uri? _buildMapsUrl() {
    if (_centers.isEmpty) {
      return null;
    }
    final firstDisposal = _selectedDisposalPositives.isEmpty
        ? null
        : (_selectedDisposalPositives.toList()..sort()).first;
    final baseTerm = (_selectedTypeLabel != null &&
            _selectedTypeLabel!.trim().isNotEmpty)
        ? _typeDisplayLabel(_selectedTypeLabel!)
        : (firstDisposal != null && firstDisposal.trim().isNotEmpty)
            ? firstDisposal
            : "Recyclinghof";
    final query = "$baseTerm ${_mapsCityLabel()}".trim();
    final params = <String, String>{
      "api": "1",
      "query": query,
    };
    return Uri.https("www.google.com", "/maps/search/", params);
  }

  List<String> _typeLabelsFrom(List<RecycleCenter> centers) {
    final values = <String>{};
    for (final center in centers) {
      final label = center.typLabel?.trim() ?? "";
      if (label.isEmpty) {
        continue;
      }
      values.add(_normalizedTypeValue(label));
    }
    final sorted = values.toList()
      ..sort((a, b) {
        if (a == _otherTypeValue && b != _otherTypeValue) {
          return 1;
        }
        if (b == _otherTypeValue && a != _otherTypeValue) {
          return -1;
        }
        return a.compareTo(b);
      });
    return sorted;
  }

  List<RecycleCenter> _filteredCenters(List<RecycleCenter> centers) {
    final selectedType = _selectedTypeLabel;
    final selectedDisposals = _selectedDisposalPositives;
    return centers.where((center) {
      final normalizedCenterType = _normalizedTypeValue(center.typLabel ?? "");
      if (selectedType != null &&
          selectedType.isNotEmpty &&
          normalizedCenterType != selectedType) {
        return false;
      }
      if (selectedDisposals.isNotEmpty &&
          !selectedDisposals.every(center.disposalPositive.contains)) {
        return false;
      }
      return true;
    }).toList();
  }

  String _normalizedTypeValue(String raw) {
    final cleaned = raw.trim();
    if (cleaned.isEmpty) {
      return cleaned;
    }
    if (cleaned.toLowerCase() == "nan") {
      return _otherTypeValue;
    }
    return cleaned;
  }

  String _typeDisplayLabel(String value) {
    if (value == _otherTypeValue) {
      return _otherTypeLabel();
    }
    return value;
  }

  String _otherTypeLabel() {
    final code = Localizations.localeOf(context).languageCode;
    switch (code) {
      case "de":
        return "Sonstige";
      case "tr":
        return "Diger";
      default:
        return "Other";
    }
  }

  List<String> _disposalOptionsFrom(List<RecycleCenter> centers) {
    final values = <String>{};
    for (final center in centers) {
      for (final item in center.disposalPositive) {
        final cleaned = item.trim();
        if (cleaned.isEmpty) {
          continue;
        }
        values.add(cleaned);
      }
    }
    final sorted = values.toList()..sort((a, b) => a.compareTo(b));
    return sorted;
  }

  String _allFilterLabel() {
    final code = Localizations.localeOf(context).languageCode;
    switch (code) {
      case "de":
        return "Alle";
      case "tr":
        return "Tumu";
      default:
        return "All";
    }
  }

  String _typeFilterLabel() {
    final code = Localizations.localeOf(context).languageCode;
    switch (code) {
      case "de":
        return "Typ";
      case "tr":
        return "Tur";
      default:
        return "Type";
    }
  }

  String _disposalFilterLabel() {
    final code = Localizations.localeOf(context).languageCode;
    switch (code) {
      case "de":
        return "Annahme";
      case "tr":
        return "Kabul";
      default:
        return "Accepted";
    }
  }

  bool _isWertstoffinsel(RecycleCenter center) {
    if (center.typCode == 5) {
      return true;
    }
    return _normalizedTypeValue(center.typLabel ?? "").toLowerCase() ==
        "wertstoffinsel";
  }

  List<String> _wertstoffinselChips(RecycleCenter center) {
    if (!_isWertstoffinsel(center)) {
      return const [];
    }
    final chips = <String>[];
    if (center.hasKleider == true) {
      chips.add("kleider");
    }
    if (center.hasPapier == true) {
      chips.add("papier");
    }
    if (center.hasGlas == true) {
      chips.add("glas");
    }
    return chips;
  }

  Future<void> _openMaps() async {
    final uri = _buildMapsUrl();
    if (uri == null) {
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _openAddress(RecycleCenter center) async {
    final hasValidCoords = center.lat.isFinite &&
        center.lng.isFinite &&
        center.lat != 0 &&
        center.lng != 0;
    final isWertstoffinsel = _isWertstoffinsel(center);

    if (hasValidCoords) {
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
        final navUri =
            Uri.parse("google.navigation:q=${center.lat},${center.lng}");
        if (await canLaunchUrl(navUri)) {
          await launchUrl(navUri, mode: LaunchMode.externalApplication);
          return;
        }
      }

      final directionsUri = Uri.https("www.google.com", "/maps/dir/", {
        "api": "1",
        "destination": "${center.lat},${center.lng}",
      });
      if (await canLaunchUrl(directionsUri)) {
        await launchUrl(directionsUri, mode: LaunchMode.externalApplication);
        return;
      }

      final searchByCoordsUri = Uri.https("www.google.com", "/maps/search/", {
        "api": "1",
        "query": "${center.lat},${center.lng}",
      });
      if (await canLaunchUrl(searchByCoordsUri)) {
        await launchUrl(searchByCoordsUri,
            mode: LaunchMode.externalApplication);
        return;
      }
    }

    final name = center.name.trim();
    final address = center.address.trim();
    final textQuery = isWertstoffinsel
        ? (address.isNotEmpty ? address : name)
        : [name, address].where((part) => part.isNotEmpty).join(", ");
    final fallbackUri = Uri.https("www.google.com", "/maps/search/", {
      "api": "1",
      "query": textQuery.isEmpty ? center.id : textQuery,
    });
    await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
  }

  String _clearFilterLabel() {
    switch (Localizations.localeOf(context).languageCode) {
      case "de":
        return "Zuruecksetzen";
      case "tr":
        return "Temizle";
      default:
        return "Clear";
    }
  }

  String _applyFilterLabel() {
    switch (Localizations.localeOf(context).languageCode) {
      case "de":
        return "Anwenden";
      case "tr":
        return "Uygula";
      default:
        return "Apply";
    }
  }

  String _filterButtonLabel({required bool active}) {
    switch (Localizations.localeOf(context).languageCode) {
      case "de":
        return active ? "Filter aktiv" : "Filter";
      case "tr":
        return active ? "Filtre aktif" : "Filtre";
      default:
        return active ? "Filter active" : "Filter";
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedTypeCode = null;
      _selectedTypeLabel = null;
      _selectedDisposalPositives = <String>{};
    });
  }

  Widget _buildActiveFilterChips(ColorScheme colorScheme) {
    final hasType = _selectedTypeLabel != null && _selectedTypeLabel!.isNotEmpty;
    final hasDisposals = _selectedDisposalPositives.isNotEmpty;
    if (!hasType && !hasDisposals) {
      return const SizedBox.shrink();
    }
    final disposalLabels = _selectedDisposalPositives.toList()..sort();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (hasType)
            InputChip(
              label: Text(_typeDisplayLabel(_selectedTypeLabel!)),
              selected: true,
              onDeleted: () {
                setState(() {
                  _selectedTypeCode = null;
                  _selectedTypeLabel = null;
                });
              },
            ),
          ...disposalLabels.map(
            (label) => InputChip(
              label: Text(label),
              selected: true,
              backgroundColor: colorScheme.surfaceContainerHigh,
              onDeleted: () {
                setState(() {
                  _selectedDisposalPositives.remove(label);
                  _selectedDisposalPositives =
                      Set<String>.from(_selectedDisposalPositives);
                });
              },
            ),
          ),
          ActionChip(
            label: Text(_clearFilterLabel()),
            avatar: const Icon(Icons.restart_alt_rounded, size: 18),
            onPressed: _clearFilters,
          ),
        ],
      ),
    );
  }

  Future<void> _showFilterSheet(
    List<String> typeLabels,
    List<String> disposalOptions,
  ) async {
    final initialType = _selectedTypeLabel;
    final initialSelection = Set<String>.from(_selectedDisposalPositives);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        final colorScheme = Theme.of(sheetContext).colorScheme;
        final textTheme = Theme.of(sheetContext).textTheme;
        String? tempType = initialType;
        final tempSelection = Set<String>.from(initialSelection);
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _typeFilterLabel(),
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        ChoiceChip(
                          selected: tempType == null,
                          label: Text(_allFilterLabel()),
                          onSelected: (_) {
                            setModalState(() {
                              tempType = null;
                            });
                          },
                        ),
                        ...typeLabels.map(
                          (label) => ChoiceChip(
                            selected: tempType == label,
                            label: Text(_typeDisplayLabel(label)),
                            onSelected: (_) {
                              setModalState(() {
                                tempType = label;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _disposalFilterLabel(),
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${disposalOptions.length} Optionen",
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(sheetContext).size.height * 0.45,
                      ),
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: disposalOptions.map((label) {
                            final selected = tempSelection.contains(label);
                            return ChoiceChip(
                              selected: selected,
                              label: Text(label),
                              onSelected: (value) {
                                setModalState(() {
                                  if (value) {
                                    tempSelection.add(label);
                                  } else {
                                    tempSelection.remove(label);
                                  }
                                });
                              },
                            );
                          }).toList(growable: false),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setModalState(() {
                                tempType = null;
                                tempSelection.clear();
                              });
                            },
                            child: Text(_clearFilterLabel()),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              setState(() {
                                _selectedTypeCode = null;
                                _selectedTypeLabel = tempType;
                                _selectedDisposalPositives =
                                    Set<String>.from(tempSelection);
                              });
                              Navigator.of(sheetContext).pop();
                            },
                            child: Text(_applyFilterLabel()),
                          ),
                        ),
                      ],
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

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final typeLabels = _typeLabelsFrom(_centers);
    final disposalOptions = _disposalOptionsFrom(_centers);
    final visibleCenters = _filteredCenters(_centers);

    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: Text(
                loc.t("find_recycling_center"),
                style:
                    DesignTokens.titleM.copyWith(color: colorScheme.onSurface),
              ),
            )
          : null,
      body: MaxWidthCenter(
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.sectionSpacing),
          child: _loading
              ? Center(
                  child: Text(
                    loc.t("recycle_centers_loading"),
                    style: DesignTokens.body
                        .copyWith(color: colorScheme.onSurface),
                  ),
                )
              : _error != null
                  ? Center(
                      child: Text(
                        loc.t("recycle_centers_error"),
                        style: DesignTokens.body
                            .copyWith(color: colorScheme.onSurface),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildActiveFilterChips(colorScheme),
                        if (_locationDenied)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              loc.t("recycle_centers_location_denied"),
                              style: DesignTokens.caption.copyWith(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: visibleCenters.isEmpty
                              ? Center(
                                  child: Text(
                                    loc.t("recycle_centers_empty"),
                                    style: DesignTokens.body.copyWith(
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  itemCount: visibleCenters.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final center = visibleCenters[index];
                                    final distance = center.distanceKm;
                                    final wertstoffinselChips =
                                        _wertstoffinselChips(center);
                                    final distanceLabel = distance == null
                                        ? null
                                        : "${distance.toStringAsFixed(1)} km";
                                    return Container(
                                      padding: const EdgeInsets.all(
                                        DesignTokens.cardPadding,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colorScheme.surface,
                                        borderRadius: BorderRadius.circular(
                                          DesignTokens.cornerRadius,
                                        ),
                                        border: Border.all(
                                          color: colorScheme.outline,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            center.name,
                                            style: DesignTokens.titleM.copyWith(
                                              color: colorScheme.onSurface,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          InkWell(
                                            onTap: () => _openAddress(center),
                                            child: Text(
                                              center.address,
                                              style: DesignTokens.body.copyWith(
                                                color: colorScheme.primary,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                          if ((center.typLabel ?? "")
                                              .trim()
                                              .isNotEmpty)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 4),
                                              child: Text(
                                                _typeDisplayLabel(
                                                  _normalizedTypeValue(
                                                    center.typLabel ?? "",
                                                  ),
                                                ),
                                                style: DesignTokens.caption
                                                    .copyWith(
                                                  color: colorScheme.onSurface
                                                      .withValues(alpha: 0.6),
                                                ),
                                              ),
                                            ),
                                          if (wertstoffinselChips.isNotEmpty)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 8),
                                              child: Wrap(
                                                spacing: 6,
                                                runSpacing: 6,
                                                children: wertstoffinselChips
                                                    .map(
                                                      (label) => Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: colorScheme
                                                              .primaryContainer,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            999,
                                                          ),
                                                        ),
                                                        child: Text(
                                                          label,
                                                          style: DesignTokens
                                                              .caption
                                                              .copyWith(
                                                            color: colorScheme
                                                                .onPrimaryContainer,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                            ),
                                          if (center
                                              .disposalPositive.isNotEmpty)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 8),
                                              child: Wrap(
                                                spacing: 6,
                                                runSpacing: 6,
                                                children: center
                                                    .disposalPositive
                                                    .map(
                                                      (label) => Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: colorScheme
                                                              .surfaceContainerHighest,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      999),
                                                          border: Border.all(
                                                            color: colorScheme
                                                                .outlineVariant,
                                                          ),
                                                        ),
                                                        child: Text(
                                                          label,
                                                          style: DesignTokens
                                                              .caption
                                                              .copyWith(
                                                            color: colorScheme
                                                                .onSurface,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                    .toList(growable: false),
                                              ),
                                            ),
                                          if (distanceLabel != null)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 4),
                                              child: Text(
                                                distanceLabel,
                                                style: DesignTokens.caption
                                                    .copyWith(
                                                  color: colorScheme.onSurface
                                                      .withValues(alpha: 0.6),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                        const SizedBox(height: 16),
                        SafeArea(
                          top: false,
                          child: Row(
                            children: [
                              Expanded(
                                child: FilledButton.icon(
                                  onPressed:
                                      (typeLabels.isEmpty &&
                                              disposalOptions.isEmpty)
                                          ? null
                                          : () => _showFilterSheet(
                                                typeLabels,
                                                disposalOptions,
                                              ),
                                  icon: const Icon(
                                    Icons.tune_rounded,
                                    size: 18,
                                  ),
                                  label: Text(
                                    _filterButtonLabel(
                                      active: _selectedDisposalPositives
                                              .isNotEmpty ||
                                          (_selectedTypeLabel != null &&
                                              _selectedTypeLabel!.isNotEmpty),
                                    ),
                                  ),
                                  style: FilledButton.styleFrom(
                                    minimumSize: const Size(0, 48),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: FilledButton.icon(
                                  onPressed:
                                      visibleCenters.isEmpty ? null : _openMaps,
                                  icon: const Icon(
                                    Icons.map_outlined,
                                    size: 18,
                                  ),
                                  label: Text(
                                    loc.t("recycle_centers_open_maps"),
                                  ),
                                  style: FilledButton.styleFrom(
                                    minimumSize: const Size(0, 48),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
