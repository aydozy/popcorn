import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/movie.dart';
import '../bloc/home_state.dart';

class MovieSection extends StatelessWidget {
  final String title;
  final MovieStatus status;
  final List<Movie> movies;
  final VoidCallback onRetry;
  final Widget Function(List<Movie>) builder;
  final Widget loadingPlaceholder;
  final VoidCallback? onSeeAllTap;

  const MovieSection({
    required this.title,
    required this.status,
    required this.movies,
    required this.onRetry,
    required this.builder,
    required this.loadingPlaceholder,
    this.onSeeAllTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 4),
          child: Row(
            children: [
              Expanded(
                child: Text(title, style: AppTextStyles.titleLarge),
              ),
              if (onSeeAllTap != null)
                GestureDetector(
                  onTap: onSeeAllTap,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'See all →',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primaryRose,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        switch (status) {
          MovieStatus.loading || MovieStatus.initial => loadingPlaceholder,
          MovieStatus.failure => _errorCard(context),
          MovieStatus.success => builder(movies),
        },
      ],
    );
  }

  Widget _errorCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_off_rounded, color: AppColors.textTertiary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Couldn\'t load this section.',
              style: AppTextStyles.bodyMedium,
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(
              'Retry',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primaryRose,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HorizontalMovieShimmer extends StatelessWidget {
  final double cardWidth;
  final double cardHeight;
  final int count;

  const HorizontalMovieShimmer({
    this.cardWidth = 120,
    this.cardHeight = 180,
    this.count = 5,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: cardHeight + 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: count,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (BuildContext context, int i) {
          return Shimmer.fromColors(
            baseColor: AppColors.surface,
            highlightColor: AppColors.surfaceElevated,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: cardWidth,
                  height: cardHeight,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 8),
                Container(width: cardWidth * 0.8, height: 12, color: AppColors.surface),
                const SizedBox(height: 4),
                Container(width: cardWidth * 0.5, height: 10, color: AppColors.surface),
              ],
            ),
          );
        },
      ),
    );
  }
}
