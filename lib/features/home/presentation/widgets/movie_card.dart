import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../watchlist/presentation/widgets/watchlist_toggle_button.dart';
import '../../domain/entities/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final double width;
  final double height;

  const MovieCard({
    required this.movie,
    this.width = 120,
    this.height = 180,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/movie/${movie.id}'),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'movie_poster_${movie.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: movie.posterUrl.isEmpty
                        ? _emptyPoster()
                        : CachedNetworkImage(
                            imageUrl: movie.posterUrl,
                            width: width,
                            height: height,
                            fit: BoxFit.cover,
                            placeholder: (BuildContext context, String url) =>
                                _shimmerPlaceholder(),
                            errorWidget: (BuildContext context, String url,
                                    Object error) =>
                                _emptyPoster(),
                          ),
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: WatchlistToggleButton(movie: movie),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              movie.title,
              style: AppTextStyles.labelMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
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
    );
  }

  Widget _shimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.surfaceElevated,
      child: Container(
        width: width,
        height: height,
        color: AppColors.surface,
      ),
    );
  }

  Widget _emptyPoster() {
    return Container(
      width: width,
      height: height,
      color: AppColors.surface,
      alignment: Alignment.center,
      child: const Icon(Icons.movie_outlined,
          color: AppColors.textTertiary, size: 32),
    );
  }
}
