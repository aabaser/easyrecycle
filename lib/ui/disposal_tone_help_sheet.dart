import "package:flutter/material.dart";

import "../l10n/app_localizations.dart";
import "../theme/design_tokens.dart";
import "disposal_bin_assets_v2.dart";
import "disposal_chip_palette.dart";

class DisposalToneHelpContent {
  const DisposalToneHelpContent({
    required this.tone,
    required this.titleKey,
    required this.bodyKey,
  });

  final String tone;
  final String titleKey;
  final String bodyKey;
}

String? disposalToneHelpToneFor(String raw) {
  final tone = disposalChipToneFor(raw);
  switch (tone) {
    case "brown":
    case "blue":
    case "yellow":
    case "gray":
      return tone;
    default:
      return null;
  }
}

bool disposalToneHelpAvailableFor(String raw) =>
    disposalToneHelpToneFor(raw) != null;

DisposalToneHelpContent? disposalToneHelpContentFor(String raw) {
  switch (disposalToneHelpToneFor(raw)) {
    case "brown":
      return const DisposalToneHelpContent(
        tone: "brown",
        titleKey: "disposal_help_brown_title",
        bodyKey: "disposal_help_brown_body",
      );
    case "blue":
      return const DisposalToneHelpContent(
        tone: "blue",
        titleKey: "disposal_help_blue_title",
        bodyKey: "disposal_help_blue_body",
      );
    case "yellow":
      return const DisposalToneHelpContent(
        tone: "yellow",
        titleKey: "disposal_help_yellow_title",
        bodyKey: "disposal_help_yellow_body",
      );
    case "gray":
      return const DisposalToneHelpContent(
        tone: "gray",
        titleKey: "disposal_help_gray_title",
        bodyKey: "disposal_help_gray_body",
      );
    default:
      return null;
  }
}

Future<void> showDisposalToneHelpSheet(
  BuildContext context, {
  required String raw,
  String? label,
}) async {
  final content = disposalToneHelpContentFor(raw);
  if (content == null) {
    return;
  }

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return _DisposalToneHelpSheet(
        content: content,
        label: label,
      );
    },
  );
}

class _DisposalToneHelpSheet extends StatelessWidget {
  const _DisposalToneHelpSheet({
    required this.content,
    this.label,
  });

  final DisposalToneHelpContent content;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);
    final colorScheme = theme.colorScheme;
    final palette = disposalChipPaletteFor(content.tone, theme.brightness);
    final assetPath = disposalBinAssetForTone(
      content.tone,
      style: theme.brightness == Brightness.dark
          ? DisposalBinStyle.outline
          : DisposalBinStyle.solid,
    );
    final sheetLabel = label?.trim();
    final title = loc.t(content.titleKey);
    final showLabel = sheetLabel != null &&
        sheetLabel.isNotEmpty &&
        sheetLabel.toLowerCase() != title.toLowerCase();

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 24,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  width: 108,
                  height: 108,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: palette.background,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: palette.border),
                  ),
                  child: Image.asset(
                    assetPath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.delete_rounded,
                      size: 44,
                      color: palette.foreground,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ),
                if (showLabel) ...[
                  const SizedBox(height: 6),
                  Text(
                    sheetLabel,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Text(
                  loc.t(content.bodyKey),
                  textAlign: TextAlign.center,
                  style: DesignTokens.body.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: DesignTokens.secondaryButtonHeight,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(loc.t("disposal_help_action")),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
