import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/popcorn_shimmer.dart';
import '../../../../shared/widgets/poster_fallback.dart';
import '../../../home/domain/entities/movie.dart';
import 'watchlist_toggle_button.dart';

class WatchlistPosterCard extends StatelessWidget {
  final Movie movie;

  const WatchlistPosterCard({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/movie/${movie.id}'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              // Same tag as Home's MovieCard → shared-element transition to
              // Detail. Safe because ShellRoute keeps only one tab mounted.
              tag: 'movie_poster_${movie.id}',
              child: movie.posterUrl.isEmpty
                  ? const PosterFallback(iconSize: 40)
                  : CachedNetworkImage(
                      imageUrl: movie.posterUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => const PopcornShimmer(),
                      errorWidget: (_, _, _) => const PosterFallback(iconSize: 40),
                      fadeInDuration: const Duration(milliseconds: 200),
                    ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.85),
                    ],
                  ),
                ),
                child: Text(
                  movie.title,
                  style: AppTextStyles.labelMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Positioned(
              top: 6,
              right: 6,
              child: WatchlistToggleButton(movie: movie, size: 34),
            ),
          ],
        ),
      ),
    );
  }

}
