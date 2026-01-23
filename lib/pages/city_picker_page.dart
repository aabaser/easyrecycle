import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../l10n/app_localizations.dart";
import "../models/city.dart";
import "../state/app_state.dart";
import "../theme/design_tokens.dart";
import "../widgets/max_width_center.dart";
import "../widgets/primary_button.dart";
import "scan_page.dart";

class CityPickerPage extends StatefulWidget {
  const CityPickerPage({super.key});

  @override
  State<CityPickerPage> createState() => _CityPickerPageState();
}

class _CityPickerPageState extends State<CityPickerPage> {
  String _query = "";
  City? _selectedCity;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final appState = context.watch<AppState>();
    _selectedCity ??= appState.selectedCity;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final appState = context.watch<AppState>();
    final colorScheme = Theme.of(context).colorScheme;
    final cities = City.defaults(
      berlinName: loc.t("city_berlin"),
      hannoverName: loc.t("city_hannover"),
    );

    final filtered = cities.where((city) {
      if (_query.trim().isEmpty) {
        return true;
      }
      return city.name.toLowerCase().contains(_query.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.t("city_title"),
          style: DesignTokens.titleM.copyWith(color: colorScheme.onSurface),
        ),
      ),
      body: MaxWidthCenter(
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.sectionSpacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: loc.t("city_search_placeholder"),
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    _query = value;
                  });
                },
              ),
              const SizedBox(height: DesignTokens.baseSpacing),
              Text(
                loc.t("city_helper"),
                style: DesignTokens.caption.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: DesignTokens.sectionSpacing),
              Expanded(
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final city = filtered[index];
                    return ListTile(
                      title: Text(city.name),
                      trailing: _selectedCity?.id == city.id
                          ? Icon(Icons.check_circle, color: colorScheme.primary)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedCity = city;
                        });
                      },
                    );
                  },
                ),
              ),
              PrimaryButton(
                label: loc.t("city_save"),
                onPressed: _selectedCity == null
                    ? null
                    : () async {
                        await appState.setSelectedCity(_selectedCity!);
                        if (!mounted) {
                          return;
                        }
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const ScanPage(),
                          ),
                        );
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
