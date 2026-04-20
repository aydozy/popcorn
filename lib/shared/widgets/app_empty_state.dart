import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

// Full-screen "nothing here" illustration + heading + optional subtitle.
// Used for an empty watchlist, no search matches, and any future list feature
// that needs the same polite dead-end screen.
class AppEmptyState extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String? subtitle;

  const AppEmptyState({
    required this.imageAsset,
    required this.title,
    this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imageAsset, width: 180),
              const SizedBox(height: 24),
              Text(
                title,
                style: AppTextStyles.headlineLarge,
                textAlign: TextAlign.center,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
