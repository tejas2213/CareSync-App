import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary brand colors
  static const Color primaryGreen = Color.fromRGBO(14, 190, 126, 1);
  static const Color primaryBlue = Color.fromRGBO(97, 206, 255, 1);

  // Gradient stops
  static const List<Color> brandGradientColors = [
    primaryBlue,
    Colors.white,
    Colors.white,
    primaryGreen,
  ];

  static const List<double> brandGradientStops = [0.0, 0.3, 0.7, 1.0];

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: brandGradientStops,
    colors: brandGradientColors,
  );

  // Semantic colors
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFF57C00);
  static const Color success = primaryGreen;
  static const Color background = Colors.white;
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color divider = Color(0xFFE0E0E0);
}
