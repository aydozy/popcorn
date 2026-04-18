import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTextStyles {
  static const String _display = 'Fraunces';
  static const String _body = 'Inter';

  // Display
  static const TextStyle displayLarge = TextStyle(
    fontFamily: _display,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );
  static const TextStyle displayMedium = TextStyle(
    fontFamily: _display,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    color: AppColors.textPrimary,
  );

  // Headline
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: _display,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: _display,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Title
  static const TextStyle titleLarge = TextStyle(
    fontFamily: _display,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const TextStyle titleMedium = TextStyle(
    fontFamily: _display,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Semantic custom
  static const TextStyle movieTitle = TextStyle(
    fontFamily: _display,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
  );
  static const TextStyle rating = TextStyle(
    fontFamily: _body,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    fontFeatures: [FontFeature.tabularFigures()],
    color: AppColors.textPrimary,
  );
  static const TextStyle button = TextStyle(
    fontFamily: _body,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    color: AppColors.textPrimary,
  );

  // Body
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _body,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.textPrimary,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _body,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textSecondary,
  );
  static const TextStyle bodySmall = TextStyle(
    fontFamily: _body,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
  );

  // Labels
  static const TextStyle labelMedium = TextStyle(
    fontFamily: _body,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
  static const TextStyle labelSmall = TextStyle(
    fontFamily: _body,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.2,
    color: AppColors.textTertiary,
  );

  static TextTheme buildTextTheme() {
    return const TextTheme(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: button,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
    );
  }
}
