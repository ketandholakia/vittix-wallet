import 'package:flutter/material.dart';
import 'package:expense_tracker/shared/theme/colors.dart';

class AppTypography {
  AppTypography._();

  static final TextTheme lightTextTheme = TextTheme(
    displayLarge: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.fontTitleLight),
    titleLarge: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.fontTitleLight),
    bodyLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.fontBodyLight),
    bodyMedium: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.fontBodyLight),
    labelLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white),
  );

  static final TextTheme darkTextTheme = TextTheme(
    displayLarge: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.fontTitleDark),
    titleLarge: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.fontTitleDark),
    bodyLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.fontBodyDark),
    bodyMedium: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.fontBodyDark),
    labelLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white),
  );
}