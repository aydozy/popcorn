import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'popcorn_button.dart';

// Shared "something went wrong" screen. Accepts either an icon or an asset
// image as the visual; both map to the same column layout. If `onRetry` is
// provided, a PopcornButton appears at the bottom.
class AppErrorState extends StatelessWidget {
  final Widget visual;
  final String title;
  final String? message;
  final VoidCallback? onRetry;
  final String retryLabel;

  const AppErrorState({
    required this.visual,
    required this.title,
    this.message,
    this.onRetry,
    this.retryLabel = 'Try again',
    super.key,
  });

  // Convenience — icon-based error (detail full page, movies list screen).
  AppErrorState.icon({
    required IconData icon,
    required this.title,
    this.message,
    this.onRetry,
    this.retryLabel = 'Try again',
    double iconSize = 64,
    Color iconColor = AppColors.textTertiary,
    super.key,
  }) : visual = Icon(icon, size: iconSize, color: iconColor);

  // Convenience — character-illustration error (search).
  AppErrorState.image({
    required String imageAsset,
    required this.title,
    this.message,
    this.onRetry,
    this.retryLabel = 'Try again',
    super.key,
  }) : visual = Image.asset(imageAsset, width: 180);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              visual,
              const SizedBox(height: 16),
              Text(
                title,
                style: AppTextStyles.headlineMedium,
                textAlign: TextAlign.center,
              ),
              if (message != null) ...[
                const SizedBox(height: 8),
                Text(
                  message!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (onRetry != null) ...[
                const SizedBox(height: 24),
                PopcornButton(label: retryLabel, onPressed: onRetry!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

