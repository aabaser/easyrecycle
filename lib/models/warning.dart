enum WarningSeverity { info, warn, danger }

class Warning {
  Warning({required this.severity, required this.messageKey});

  final WarningSeverity severity;
  final String messageKey;
}
