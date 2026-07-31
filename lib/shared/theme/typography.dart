import 'package:flutter/material.dart';
import 'package:expense_tracker/core/theme/vittix_colors.dart';

class AppTypography {
  AppTypography._();

  static final TextTheme lightTextTheme = TextTheme(
    displayLarge: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: VittixColors.textPrimary),
    titleLarge: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: VittixColors.textPrimary),
    bodyLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: VittixColors.textPrimary),
    bodyMedium: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: VittixColors.textSecondary),
    labelLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
  );

  static final TextTheme darkTextTheme = TextTheme(
    displayLarge: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
    titleLarge: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
    bodyLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Color(0xFFD7E3F5)),
    bodyMedium: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Color(0xFFB7C6DA)),
    labelLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
  );
}
