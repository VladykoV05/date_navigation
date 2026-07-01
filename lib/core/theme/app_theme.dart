import 'package:flutter/material.dart';

enum AppThemePreset { calmPremium, monoLuxury }

class AppTheme {
  const AppTheme._();

  // Quick visual switch for live comparisons.
  static const AppThemePreset preset = AppThemePreset.calmPremium;

  static const Color _brand = Color(0xFF5E47FF);
  static const Color _lightBg = Color(0xFFF3F5FA);
  static const Color _darkBg = Color(0xFF0F1218);
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _darkSurface = Color(0xFF161B24);
  static const Color _lightOutline = Color(0xFFD9DEE8);
  static const Color _darkOutline = Color(0xFF2C3442);
  static const Color _lightText = Color(0xFF121722);
  static const Color _darkText = Color(0xFFEAF0FF);
  static const Color _lightSubtle = Color(0xFF6D7485);
  static const Color _darkSubtle = Color(0xFF9DA8BF);

  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: _brand,
    onPrimary: Colors.white,
    secondary: Color(0xFF6676A8),
    onSecondary: Colors.white,
    error: Color(0xFFB23A4B),
    onError: Colors.white,
    surface: _lightSurface,
    onSurface: _lightText,
    primaryContainer: Color(0xFFE5E0FF),
    onPrimaryContainer: Color(0xFF281D75),
    secondaryContainer: Color(0xFFE3E9F8),
    onSecondaryContainer: Color(0xFF1C2233),
    errorContainer: Color(0xFFFFE7EA),
    onErrorContainer: Color(0xFF3D0A12),
    surfaceContainerHighest: Color(0xFFEAEFF7),
    onSurfaceVariant: _lightSubtle,
    outline: _lightOutline,
    outlineVariant: Color(0xFFE2E7EF),
    shadow: Color(0x26000000),
    scrim: Color(0x33000000),
    inverseSurface: Color(0xFF222A38),
    onInverseSurface: Color(0xFFE8EEF9),
    inversePrimary: Color(0xFFC6BDFF),
  );

  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFBDB4FF),
    onPrimary: Color(0xFF2F2388),
    secondary: Color(0xFF9CA8C9),
    onSecondary: Color(0xFF222B40),
    error: Color(0xFFFFB4BF),
    onError: Color(0xFF5F1120),
    surface: _darkSurface,
    onSurface: _darkText,
    primaryContainer: Color(0xFF3A2E9D),
    onPrimaryContainer: Color(0xFFEAE6FF),
    secondaryContainer: Color(0xFF2A3245),
    onSecondaryContainer: Color(0xFFDDE4F8),
    errorContainer: Color(0xFF5E1B28),
    onErrorContainer: Color(0xFFFFDCE1),
    surfaceContainerHighest: Color(0xFF202736),
    onSurfaceVariant: _darkSubtle,
    outline: _darkOutline,
    outlineVariant: Color(0xFF323B4C),
    shadow: Color(0x59000000),
    scrim: Color(0x59000000),
    inverseSurface: Color(0xFFE7EDF9),
    onInverseSurface: Color(0xFF202837),
    inversePrimary: _brand,
  );

  static const ColorScheme _monoLightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF4E5768),
    onPrimary: Colors.white,
    secondary: Color(0xFF71798A),
    onSecondary: Colors.white,
    error: Color(0xFFAA4A57),
    onError: Colors.white,
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF141821),
    primaryContainer: Color(0xFFE8EBF1),
    onPrimaryContainer: Color(0xFF1A2130),
    secondaryContainer: Color(0xFFECEFF4),
    onSecondaryContainer: Color(0xFF1E2533),
    errorContainer: Color(0xFFF8E8EB),
    onErrorContainer: Color(0xFF3F1118),
    surfaceContainerHighest: Color(0xFFEFF2F6),
    onSurfaceVariant: Color(0xFF6D7483),
    outline: Color(0xFFD9DEE6),
    outlineVariant: Color(0xFFE4E8EE),
    shadow: Color(0x26000000),
    scrim: Color(0x33000000),
    inverseSurface: Color(0xFF222937),
    onInverseSurface: Color(0xFFE9EEF8),
    inversePrimary: Color(0xFFC5CFDE),
  );

  static const ColorScheme _monoDarkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFC2CAD8),
    onPrimary: Color(0xFF2B3344),
    secondary: Color(0xFFA5AFBF),
    onSecondary: Color(0xFF2C3445),
    error: Color(0xFFF6B8C1),
    onError: Color(0xFF5A1722),
    surface: Color(0xFF141922),
    onSurface: Color(0xFFE7ECF5),
    primaryContainer: Color(0xFF323B4E),
    onPrimaryContainer: Color(0xFFE7ECF5),
    secondaryContainer: Color(0xFF2A3242),
    onSecondaryContainer: Color(0xFFDDE4F3),
    errorContainer: Color(0xFF5C1E28),
    onErrorContainer: Color(0xFFFFDCE2),
    surfaceContainerHighest: Color(0xFF202837),
    onSurfaceVariant: Color(0xFF9DA7B9),
    outline: Color(0xFF313A4A),
    outlineVariant: Color(0xFF374153),
    shadow: Color(0x59000000),
    scrim: Color(0x59000000),
    inverseSurface: Color(0xFFE6EBF4),
    onInverseSurface: Color(0xFF202736),
    inversePrimary: Color(0xFF5D6779),
  );

  static ThemeData light() {
    final scheme = switch (preset) {
      AppThemePreset.calmPremium => _lightScheme,
      AppThemePreset.monoLuxury => _monoLightScheme,
    };
    final bg = switch (preset) {
      AppThemePreset.calmPremium => _lightBg,
      AppThemePreset.monoLuxury => const Color(0xFFF4F6F9),
    };
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: bg,
      textTheme: _textTheme(Brightness.light),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(color: scheme.onInverseSurface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  static ThemeData dark() {
    final scheme = switch (preset) {
      AppThemePreset.calmPremium => _darkScheme,
      AppThemePreset.monoLuxury => _monoDarkScheme,
    };
    final bg = switch (preset) {
      AppThemePreset.calmPremium => _darkBg,
      AppThemePreset.monoLuxury => const Color(0xFF10141D),
    };
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: bg,
      textTheme: _textTheme(Brightness.dark),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(color: scheme.onInverseSurface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: _darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  static TextTheme _textTheme(Brightness brightness) {
    final base = brightness == Brightness.dark
        ? Typography.whiteMountainView
        : Typography.blackMountainView;
    return base.copyWith(
      headlineSmall: base.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      bodyMedium: base.bodyMedium?.copyWith(height: 1.35),
      labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
