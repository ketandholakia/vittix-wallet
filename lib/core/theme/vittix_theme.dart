import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'vittix_colors.dart';

class VittixTheme {
  VittixTheme._();

  static final TextTheme _lightTextTheme = GoogleFonts.interTextTheme().apply(
    bodyColor: VittixColors.textPrimary,
    displayColor: VittixColors.textPrimary,
  );

  static final TextTheme _darkTextTheme = GoogleFonts.interTextTheme().apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  );

  static ThemeData light() {
    const colorScheme = ColorScheme.light(
      primary: VittixColors.primaryNavy,
      onPrimary: Colors.white,
      secondary: VittixColors.accentGreen,
      onSecondary: VittixColors.textPrimary,
      error: VittixColors.errorRed,
      onError: Colors.white,
      surface: VittixColors.lightSurface,
      onSurface: VittixColors.textPrimary,
      outline: VittixColors.border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: VittixColors.lightBackground,
      primaryColor: VittixColors.primaryNavy,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: _lightTextTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: VittixColors.primaryNavy,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: VittixColors.lightSurface,
        elevation: 2,
        shadowColor: VittixColors.primaryNavy.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.zero,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: VittixColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: VittixColors.accentGreen,
        foregroundColor: VittixColors.textPrimary,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: VittixColors.lightSurface,
        selectedItemColor: VittixColors.primaryNavy,
        unselectedItemColor: VittixColors.textSecondary,
        type: BottomNavigationBarType.fixed,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: VittixColors.accentGreen,
          foregroundColor: VittixColors.textPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: VittixColors.accentGreen,
          foregroundColor: VittixColors.textPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: VittixColors.primaryNavy),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: VittixColors.lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: VittixColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: VittixColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: VittixColors.primaryNavy, width: 1.5),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: VittixColors.primaryNavy,
        contentTextStyle: TextStyle(color: Colors.white),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: VittixColors.accentGreen,
        linearTrackColor: VittixColors.border,
      ),
      dividerTheme: const DividerThemeData(color: VittixColors.border),
    );
  }

  static ThemeData dark() {
    const colorScheme = ColorScheme.dark(
      primary: VittixColors.accentGreen,
      onPrimary: VittixColors.textPrimary,
      secondary: VittixColors.accentGreen,
      onSecondary: VittixColors.textPrimary,
      error: VittixColors.errorRed,
      onError: Colors.white,
      surface: VittixColors.darkSurface,
      onSurface: Colors.white,
      outline: Color(0xFF28415E),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: VittixColors.darkBackground,
      primaryColor: VittixColors.primaryNavy,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: _darkTextTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: VittixColors.darkBackground,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: VittixColors.darkSurface,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.zero,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: VittixColors.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: VittixColors.accentGreen,
        foregroundColor: VittixColors.textPrimary,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: VittixColors.darkSurface,
        selectedItemColor: VittixColors.accentGreen,
        unselectedItemColor: Color(0xFF93A4BA),
        type: BottomNavigationBarType.fixed,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: VittixColors.accentGreen,
          foregroundColor: VittixColors.textPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: VittixColors.accentGreen,
          foregroundColor: VittixColors.textPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: VittixColors.accentGreen),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: VittixColors.darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF28415E)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF28415E)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: VittixColors.accentGreen, width: 1.5),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: VittixColors.darkSurface,
        contentTextStyle: TextStyle(color: Colors.white),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: VittixColors.accentGreen,
        linearTrackColor: Color(0xFF28415E),
      ),
      dividerTheme: const DividerThemeData(color: Color(0xFF28415E)),
    );
  }
}
