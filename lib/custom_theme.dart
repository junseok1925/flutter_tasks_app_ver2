import 'package:flutter/material.dart';

/// Custom color palette hooked into ThemeExtension so it can be part of ThemeData.
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.main,
    required this.mainLight,
    required this.sub,
    required this.background,
  });

  final Color main;
  final Color mainLight;
  final Color sub;
  final Color background;

  /// Default light mode colors.
  static const AppThemeExtension light = AppThemeExtension(
    main: Color(0xFF1976D2),
    mainLight: Color(0xFF63A4FF),
    sub: Color(0xFF546E7A),
    background: Color(0xFFF5F7FB),
  );

  /// Default dark mode colors.
  static const AppThemeExtension dark = AppThemeExtension(
    main: Color(0xFF90CAF9),
    mainLight: Color(0xFFBBDEFB),
    sub: Color(0xFFB0BEC5),
    background: Color(0xFF0F172A),
  );

  @override
  AppThemeExtension copyWith({
    Color? main,
    Color? mainLight,
    Color? sub,
    Color? background,
  }) {
    return AppThemeExtension(
      main: main ?? this.main,
      mainLight: mainLight ?? this.mainLight,
      sub: sub ?? this.sub,
      background: background ?? this.background,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      main: Color.lerp(main, other.main, t) ?? main,
      mainLight: Color.lerp(mainLight, other.mainLight, t) ?? mainLight,
      sub: Color.lerp(sub, other.sub, t) ?? sub,
      background: Color.lerp(background, other.background, t) ?? background,
    );
  }
}
