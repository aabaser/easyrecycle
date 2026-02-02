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
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: cities.map((city) {
        final isSelected = city.id == selectedCityId;
        return ChoiceChip(
          label: Text(
            city.name,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFF4338CA)
                  : colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          selected: isSelected,
          showCheckmark: false,
          selectedColor: const Color(0xFF4338CA).withOpacity(0.12),
          backgroundColor: colorScheme.surface,
          side: BorderSide(
            color: isSelected
                ? const Color(0xFF4338CA)
                : colorScheme.outline.withOpacity(0.6),
          ),
          onSelected: (_) => onSelected(city),
        );
      }).toList(),
    );
  }
}
