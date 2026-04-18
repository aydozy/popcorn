import 'package:flutter/material.dart';

abstract final class AppColors {
  // Surfaces
  static const Color background = Color(0xFF0F172A);
  static const Color surface = Color(0xFF1E293B);
  static const Color surfaceElevated = Color(0xFF334155);
  static final Color border = const Color(0xFF334155).withValues(alpha: 0.30);

  // Primary
  static const Color primaryRed = Color(0xFFE11D48);
  static const Color primaryRose = Color(0xFFF43F5E);
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryRed, primaryRose],
  );

  // Accent
  static const Color accentGold = Color(0xFFF59E0B);
  static const Color accentGoldLight = Color(0xFFFCD34D);
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentGold, accentGoldLight],
  );

  // Text
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textTertiary = Color(0xFF64748B);

  // Semantic
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFF43F5E);

  // Shadows
  static final Color shadowCinema = const Color(0xFFE11D48).withValues(alpha: 0.15);
  static final Color shadowDefault = Colors.black.withValues(alpha: 0.40);
}
