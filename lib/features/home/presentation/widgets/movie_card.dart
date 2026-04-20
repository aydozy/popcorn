import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/movie_rating.dart';
import '../../../../shared/widgets/popcorn_shimmer.dart';
import '../../../../shared/widgets/poster_fallback.dart';
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
                    child: SizedBox(
                      width: width,
                      height: height,
                      child: movie.posterUrl.isEmpty
                          ? const PosterFallback()
                          : CachedNetworkImage(
                              imageUrl: movie.posterUrl,
                              fit: BoxFit.cover,
                              placeholder:
                                  (BuildContext context, String url) =>
                                      const PopcornShimmer(),
                              errorWidget: (BuildContext context, String url,
                                      Object error) =>
                                  const PosterFallback(),
                            ),
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
            MovieRating(movie.voteAverage),
          ],
        ),
      ),
    );
  }

}
