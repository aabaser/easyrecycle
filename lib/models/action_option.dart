enum ActionType { donate, sell, repair, reuse }

class ActionOption {
  ActionOption({
    required this.type,
    required this.titleKey,
    this.descriptionKey,
    this.ctaKey,
    required this.priority,
  });

  final ActionType type;
  final String titleKey;
  final String? descriptionKey;
  final String? ctaKey;
  final int priority;
}
