import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../watchlist/presentation/widgets/watchlist_toggle_button.dart';
import '../../domain/entities/movie.dart';

class MovieListItem extends StatelessWidget {
  final Movie movie;

  const MovieListItem({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/movie/${movie.id}'),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: movie.posterUrl.isEmpty
                  ? _emptyPoster()
                  : CachedNetworkImage(
                      imageUrl: movie.posterUrl,
                      width: 56,
                      height: 84,
                      fit: BoxFit.cover,
                      placeholder: (BuildContext context, String url) =>
                          _shimmerPlaceholder(),
                      errorWidget:
                          (BuildContext context, String url, Object error) =>
                              _emptyPoster(),
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    movie.title,
                    style: AppTextStyles.labelMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (movie.year.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      movie.year,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          size: 14, color: AppColors.accentGold),
                      const SizedBox(width: 4),
                      Text(
                        movie.voteAverage.toStringAsFixed(1),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            WatchlistToggleButton(movie: movie, size: 30),
          ],
        ),
      ),
    );
  }

  Widget _shimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.surfaceElevated,
      child: Container(
        width: 56,
        height: 84,
        color: AppColors.surface,
      ),
    );
  }

  Widget _emptyPoster() {
    return Container(
      width: 56,
      height: 84,
      color: AppColors.surfaceElevated,
      alignment: Alignment.center,
      child: const Icon(Icons.movie_outlined,
          color: AppColors.textTertiary, size: 20),
    );
  }
}
