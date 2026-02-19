import "dart:ui";

import "package:flutter/material.dart";

@immutable
class ERSpacing extends ThemeExtension<ERSpacing> {
  const ERSpacing({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
  });

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;

  static const ERSpacing comfy = ERSpacing(
    xs: 4,
    sm: 8,
    md: 12,
    lg: 16,
    xl: 24,
    xxl: 32,
  );

  @override
  ERSpacing copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
  }) {
    return ERSpacing(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
    );
  }

  @override
  ERSpacing lerp(ThemeExtension<ERSpacing>? other, double t) {
    if (other is! ERSpacing) {
      return this;
    }
    return ERSpacing(
      xs: lerpDouble(xs, other.xs, t)!,
      sm: lerpDouble(sm, other.sm, t)!,
      md: lerpDouble(md, other.md, t)!,
      lg: lerpDouble(lg, other.lg, t)!,
      xl: lerpDouble(xl, other.xl, t)!,
      xxl: lerpDouble(xxl, other.xxl, t)!,
    );
  }
}

@immutable
class ERRadii extends ThemeExtension<ERRadii> {
  const ERRadii({
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.pill,
  });

  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double pill;

  static const ERRadii comfy = ERRadii(
    sm: 12,
    md: 16,
    lg: 20,
    xl: 24,
    pill: 999,
  );

  @override
  ERRadii copyWith({
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? pill,
  }) {
    return ERRadii(
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      pill: pill ?? this.pill,
    );
  }

  @override
  ERRadii lerp(ThemeExtension<ERRadii>? other, double t) {
    if (other is! ERRadii) {
      return this;
    }
    return ERRadii(
      sm: lerpDouble(sm, other.sm, t)!,
      md: lerpDouble(md, other.md, t)!,
      lg: lerpDouble(lg, other.lg, t)!,
      xl: lerpDouble(xl, other.xl, t)!,
      pill: lerpDouble(pill, other.pill, t)!,
    );
  }
}

@immutable
class ERSurfaces extends ThemeExtension<ERSurfaces> {
  const ERSurfaces({
    required this.softSurface,
    required this.imageFallback,
  });

  final Color softSurface;
  final Color imageFallback;

  @override
  ERSurfaces copyWith({
    Color? softSurface,
    Color? imageFallback,
  }) {
    return ERSurfaces(
      softSurface: softSurface ?? this.softSurface,
      imageFallback: imageFallback ?? this.imageFallback,
    );
  }

  @override
  ERSurfaces lerp(ThemeExtension<ERSurfaces>? other, double t) {
    if (other is! ERSurfaces) {
      return this;
    }
    return ERSurfaces(
      softSurface: Color.lerp(softSurface, other.softSurface, t)!,
      imageFallback: Color.lerp(imageFallback, other.imageFallback, t)!,
    );
  }
}
