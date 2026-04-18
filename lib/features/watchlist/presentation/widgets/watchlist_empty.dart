import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class WatchlistEmpty extends StatelessWidget {
  const WatchlistEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/characters/connection_popcorn.png',
            width: 180,
          ),
          const SizedBox(height: 24),
          Text(
            'Your watchlist is empty',
            style: AppTextStyles.headlineLarge,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Save movies you want to watch later and find them all here.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
