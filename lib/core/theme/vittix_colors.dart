import 'package:flutter/material.dart';

class VittixColors {
  VittixColors._();

  static const Color primaryNavy = Color(0xFF0B1F3A);
  static const Color darkBackground = Color(0xFF071524);
  static const Color darkSurface = Color(0xFF102846);
  static const Color accentGreen = Color(0xFF5AD84F);
  static const Color successGreen = Color(0xFF22C55E);
  static const Color warningAmber = Color(0xFFF59E0B);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);

  static const Color income = successGreen;
  static const Color loss = errorRed;

  static const Gradient navyGradient = LinearGradient(
    colors: [darkBackground, primaryNavy, Color(0xFF12315A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
