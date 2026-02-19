import "package:flutter/material.dart";

import "../models/city.dart";

class CityPills extends StatelessWidget {
  const CityPills({
    super.key,
    required this.cities,
    required this.selectedCityId,
    required this.onSelected,
  });

  final List<City> cities;
  final String? selectedCityId;
  final ValueChanged<City> onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: cities.map((city) {
        final isSelected = city.id == selectedCityId;
        return ChoiceChip(
          label: Text(
            city.name,
            style: textTheme.labelLarge?.copyWith(
              color: isSelected ? colorScheme.primary : colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          selected: isSelected,
          showCheckmark: false,
          selectedColor: colorScheme.primaryContainer,
          backgroundColor: colorScheme.surfaceContainerLow,
          side: BorderSide(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
            width: isSelected ? 1.2 : 1,
          ),
          onSelected: (_) => onSelected(city),
        );
      }).toList(),
    );
  }
}
