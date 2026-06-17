import 'package:flutter/material.dart';
import 'package:expense_tracker/shared/theme/colors.dart';
import 'package:expense_tracker/shared/theme/typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryLight,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    cardColor: AppColors.cardLight,
    textTheme: AppTypography.lightTextTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryLight,
      titleTextStyle: AppTypography.lightTextTheme.titleLarge?.copyWith(color: AppColors.white),
      iconTheme: const IconThemeData(color: AppColors.white),
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryLight,
      secondary: AppColors.primaryLight,
      background: AppColors.backgroundLight,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: AppColors.white,
        textStyle: AppTypography.lightTextTheme.labelLarge,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryDark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    cardColor: AppColors.cardDark,
    textTheme: AppTypography.darkTextTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.cardDark,
      titleTextStyle: AppTypography.darkTextTheme.titleLarge,
      iconTheme: const IconThemeData(color: AppColors.primaryDark),
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryDark,
      secondary: AppColors.primaryDark,
      background: AppColors.backgroundDark,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: AppColors.fontTitleLight,
        textStyle: AppTypography.darkTextTheme.labelLarge,
      ),
    ),
  );
}