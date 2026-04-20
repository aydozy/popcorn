import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

// Compact "⭐ 8.9" row used wherever a Movie's TMDB score is shown on a card:
// MovieCard, MovieListItem, SearchResultItem. Keeps icon size / color / spacing
// identical in one place.
class MovieRating extends StatelessWidget {
  final double voteAverage;

  const MovieRating(this.voteAverage, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, size: 14, color: AppColors.accentGold),
        const SizedBox(width: 4),
        Text(
          voteAverage.toStringAsFixed(1),
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
