import "package:flutter/material.dart";

import "../l10n/app_localizations.dart";
import "../models/action_option.dart";
import "../theme/design_tokens.dart";

class ActionCard extends StatelessWidget {
  const ActionCard({super.key, required this.option, this.titlePrefix});

  final ActionOption option;
  final String? titlePrefix;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final title = loc.t(option.titleKey);
    final description =
        option.descriptionKey != null ? loc.t(option.descriptionKey!) : null;
    final cta =
        option.ctaKey != null ? loc.t(option.ctaKey!) : loc.t("action_details");

    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.baseSpacing),
      padding: const EdgeInsets.all(DesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadius),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titlePrefix != null ? "$titlePrefix $title" : title,
            style: DesignTokens.titleM.copyWith(color: colorScheme.onSurface),
          ),
          if (description != null) ...[
            const SizedBox(height: 4),
            Text(
              description,
              style: DesignTokens.body.copyWith(color: colorScheme.onSurface),
            ),
          ],
          const SizedBox(height: 6),
          Text(
            cta,
            style: DesignTokens.caption.copyWith(color: colorScheme.primary),
          ),
        ],
      ),
    );
  }
}
