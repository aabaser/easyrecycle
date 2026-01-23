import "package:flutter/material.dart";
import "../l10n/app_localizations.dart";
import "../models/warning.dart";
import "../theme/app_colors.dart";
import "../theme/design_tokens.dart";

class InfoBanner extends StatelessWidget {
  const InfoBanner({super.key, required this.warning});

  final Warning warning;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final colors = _resolveColors();
    final title = _titleForSeverity(loc);

    return Container(
      padding: const EdgeInsets.all(DesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadius),
        border: Border.all(color: colors.text.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: DesignTokens.titleM.copyWith(color: colors.text),
          ),
          const SizedBox(height: 4),
          Text(
            loc.t(warning.messageKey),
            style: DesignTokens.body.copyWith(color: colors.text),
          ),
        ],
      ),
    );
  }

  _InfoBannerColors _resolveColors() {
    switch (warning.severity) {
      case WarningSeverity.danger:
        return _InfoBannerColors(
          background: AppColors.error.withOpacity(0.12),
          text: AppColors.error,
        );
      case WarningSeverity.warn:
        return _InfoBannerColors(
          background: AppColors.warning.withOpacity(0.15),
          text: AppColors.warning,
        );
      case WarningSeverity.info:
        return _InfoBannerColors(
          background: AppColors.info.withOpacity(0.12),
          text: AppColors.info,
        );
    }
  }

  String _titleForSeverity(AppLocalizations loc) {
    switch (warning.severity) {
      case WarningSeverity.danger:
        return loc.t("warning_danger");
      case WarningSeverity.warn:
        return loc.t("warning_warn");
      case WarningSeverity.info:
        return loc.t("warning_info");
    }
  }
}

class _InfoBannerColors {
  _InfoBannerColors({required this.background, required this.text});

  final Color background;
  final Color text;
}
