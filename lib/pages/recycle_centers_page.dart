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
  const RecycleCentersPage({super.key, this.cityCode});

  final String? cityCode;

  @override
  State<RecycleCentersPage> createState() => _RecycleCentersPageState();
}

class _RecycleCentersPageState extends State<RecycleCentersPage> {
  bool _loading = true;
  String? _error;
  bool _locationDenied = false;
  Position? _position;
  List<RecycleCenter> _centers = [];
  String _cityCode = "hannover";

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final appState = context.read<AppState>();
    final cityCode = widget.cityCode ?? appState.selectedCity?.id ?? "hannover";
    _cityCode = cityCode;
    Position? position;
    var locationDenied = false;

    if (kIsWeb) {
      locationDenied = true;
    } else {
      try {
        final serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (serviceEnabled) {
          var permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
          }
          if (permission == LocationPermission.denied ||
              permission == LocationPermission.deniedForever) {
            locationDenied = true;
          } else {
            position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.low,
            );
          }
        } else {
          locationDenied = true;
        }
      } catch (_) {
        locationDenied = true;
      }
    }

    try {
      final centers = await RecycleCenterService.fetchCenters(
        appState: appState,
        cityCode: cityCode,
        lat: position?.latitude,
        lng: position?.longitude,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _centers = centers;
        _position = position;
        _locationDenied = locationDenied;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = "load_failed";
        _locationDenied = locationDenied;
        _loading = false;
      });
    }
  }

  Uri? _buildMapsUrl() {
    if (_centers.isEmpty) {
      return null;
    }
    final query = _position != null
        ? "Recyclinghof near ${_position!.latitude},${_position!.longitude}"
        : "Recyclinghof $_cityCode";
    final params = <String, String>{
      "api": "1",
      "query": query,
    };
    return Uri.https("www.google.com", "/maps/search/", params);
  }

  Future<void> _openMaps() async {
    final uri = _buildMapsUrl();
    if (uri == null) {
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _openAddress(RecycleCenter center) async {
    final name = center.name.trim();
    final query = name.isEmpty
        ? "${center.lat},${center.lng}"
        : "$name ${center.lat},${center.lng}";
    final params = <String, String>{
      "api": "1",
      "query": query,
    };
    final uri = Uri.https("www.google.com", "/maps/search/", params);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.t("find_recycling_center"),
          style: DesignTokens.titleM.copyWith(color: colorScheme.onSurface),
        ),
      ),
      body: MaxWidthCenter(
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.sectionSpacing),
          child: _loading
              ? Center(
                  child: Text(
                    loc.t("recycle_centers_loading"),
                    style:
                        DesignTokens.body.copyWith(color: colorScheme.onSurface),
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
                        if (_locationDenied)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              loc.t("recycle_centers_location_denied"),
                              style: DesignTokens.caption.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ),
                        SizedBox(
                          width: double.infinity,
                          height: DesignTokens.primaryButtonHeight,
                          child: ElevatedButton(
                            onPressed: _centers.isEmpty ? null : _openMaps,
                            child: Text(loc.t("recycle_centers_open_maps")),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: _centers.isEmpty
                              ? Center(
                                  child: Text(
                                    loc.t("recycle_centers_empty"),
                                    style: DesignTokens.body.copyWith(
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  itemCount: _centers.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final center = _centers[index];
                                    final distance = center.distanceKm;
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
                                                decoration: TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                          if (center.typLabel != null &&
                                              center.typLabel!.isNotEmpty)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 4),
                                              child: Text(
                                                center.typLabel!,
                                                style: DesignTokens.caption
                                                    .copyWith(
                                                  color: colorScheme.onSurface
                                                      .withOpacity(0.6),
                                                ),
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
                                                      .withOpacity(0.6),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
