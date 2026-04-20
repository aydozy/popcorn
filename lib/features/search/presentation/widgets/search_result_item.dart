import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/movie_rating.dart';
import '../../../../shared/widgets/popcorn_shimmer.dart';
import '../../../../shared/widgets/poster_fallback.dart';
import '../../../home/domain/entities/movie.dart';
import '../../../watchlist/presentation/widgets/watchlist_toggle_button.dart';
import '../../domain/entities/genre_category.dart';

class SearchResultItem extends StatelessWidget {
  final Movie movie;

  const SearchResultItem({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push('/movie/${movie.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _poster(),
            const SizedBox(width: 16),
            Expanded(child: _body()),
            const SizedBox(width: 8),
            WatchlistToggleButton(movie: movie, size: 30),
          ],
        ),
      ),
    );
  }

  Widget _poster() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 70,
        height: 105,
        child: movie.posterUrl.isEmpty
            ? const PosterFallback(iconSize: 24)
            : CachedNetworkImage(
                imageUrl: movie.posterUrl,
                fit: BoxFit.cover,
                placeholder: (_, _) => const PopcornShimmer(),
                errorWidget: (_, _, _) =>
                    const PosterFallback(iconSize: 24),
              ),
      ),
    );
  }

  Widget _body() {
    final String year = movie.year;
    final String? firstGenre = movie.genreIds.isEmpty
        ? null
        : MovieGenres.byId(movie.genreIds.first)?.name;
    final String meta = [
      if (year.isNotEmpty) year,
      ?firstGenre,
    ].join('  •  ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          movie.title,
          style: AppTextStyles.movieTitle.copyWith(fontSize: 16),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (meta.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            meta,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const SizedBox(height: 4),
        MovieRating(movie.voteAverage),
        if (movie.overview.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            movie.overview,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
