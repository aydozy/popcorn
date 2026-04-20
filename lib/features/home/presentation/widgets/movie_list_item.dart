import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/movie_rating.dart';
import '../../../../shared/widgets/popcorn_shimmer.dart';
import '../../../../shared/widgets/poster_fallback.dart';
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
              child: SizedBox(
                width: 56,
                height: 84,
                child: movie.posterUrl.isEmpty
                    ? const PosterFallback(
                        iconSize: 20,
                        backgroundColor: AppColors.surfaceElevated,
                      )
                    : CachedNetworkImage(
                        imageUrl: movie.posterUrl,
                        fit: BoxFit.cover,
                        placeholder: (BuildContext context, String url) =>
                            const PopcornShimmer(),
                        errorWidget: (BuildContext context, String url,
                                Object error) =>
                            const PosterFallback(
                          iconSize: 20,
                          backgroundColor: AppColors.surfaceElevated,
                        ),
                      ),
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
                  MovieRating(movie.voteAverage),
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

}
