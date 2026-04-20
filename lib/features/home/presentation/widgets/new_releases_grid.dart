import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/popcorn_shimmer.dart';
import '../../domain/entities/movie.dart';
import 'movie_list_item.dart';

class NewReleasesGrid extends StatelessWidget {
  final List<Movie> movies;
  final int maxItems;

  const NewReleasesGrid({
    required this.movies,
    this.maxItems = 8,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<Movie> visible = movies.take(maxItems).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          for (int i = 0; i < visible.length; i += 2) ...[
            if (i > 0) const SizedBox(height: 12),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: MovieListItem(movie: visible[i])),
                  const SizedBox(width: 12),
                  Expanded(
                    child: i + 1 < visible.length
                        ? MovieListItem(movie: visible[i + 1])
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Matches NewReleasesGrid's silhouette (2-column rows of MovieListItem) so the
// transition from loading → loaded doesn't jump between a horizontal row of
// cards and the vertical grid.
class NewReleasesShimmer extends StatelessWidget {
  final int rows;

  const NewReleasesShimmer({this.rows = 4, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: PopcornShimmer(
        child: Column(
          children: [
            for (int i = 0; i < rows; i++) ...[
              if (i > 0) const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _skeletonRow()),
                  const SizedBox(width: 12),
                  Expanded(child: _skeletonRow()),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _skeletonRow() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 84,
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  height: 10,
                  color: AppColors.surfaceElevated,
                ),
                const SizedBox(height: 6),
                Container(
                  width: 80,
                  height: 10,
                  color: AppColors.surfaceElevated,
                ),
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 8,
                  color: AppColors.surfaceElevated,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
