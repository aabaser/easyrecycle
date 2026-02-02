import "package:flutter/material.dart";

class LanguageSegment extends StatelessWidget {
  const LanguageSegment({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const options = ["de", "en", "tr"];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((code) {
          final isSelected = code == selected;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => onChanged(code),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF4338CA).withOpacity(0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  code.toUpperCase(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                        color: isSelected
                            ? const Color(0xFF4338CA)
                            : const Color(0xFF0B1220).withOpacity(0.6),
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
