import "package:flutter/material.dart";

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.primaryColor,
    required this.outlineColor,
    required this.textColor,
  });

  final String selected;
  final ValueChanged<String> onChanged;
  final Color primaryColor;
  final Color outlineColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    const options = ["DE", "EN", "TR"];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: outlineColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((code) {
          final isSelected = code.toLowerCase() == selected;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => onChanged(code.toLowerCase()),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  code,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : textColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
