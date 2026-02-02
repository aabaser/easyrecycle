import "package:flutter/material.dart";

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const options = ["de", "en", "tr"];
    return Wrap(
      spacing: 8,
      children: options.map((code) {
        final isSelected = code == selected;
        return ChoiceChip(
          label: Text(
            code.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
            ),
          ),
          selected: isSelected,
          selectedColor: const Color(0xFF4338CA),
          backgroundColor: colorScheme.surface,
          side: BorderSide(
            color: isSelected
                ? const Color(0xFF4338CA)
                : colorScheme.outline.withOpacity(0.6),
          ),
          onSelected: (_) => onChanged(code),
        );
      }).toList(),
    );
  }
}
