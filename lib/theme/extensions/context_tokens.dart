import "package:flutter/material.dart";

import "app_tokens.dart";

extension ERThemeContext on BuildContext {
  ERSpacing get spacing =>
      Theme.of(this).extension<ERSpacing>() ?? ERSpacing.comfy;

  ERRadii get radii => Theme.of(this).extension<ERRadii>() ?? ERRadii.comfy;

  ERSurfaces get surfaces =>
      Theme.of(this).extension<ERSurfaces>() ??
      ERSurfaces(
        softSurface: Theme.of(this).colorScheme.surfaceContainerHighest,
        imageFallback: Theme.of(
          this,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
      );
}
