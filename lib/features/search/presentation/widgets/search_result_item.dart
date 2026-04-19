import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
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
      child: movie.posterUrl.isEmpty
          ? _emptyPoster()
          : CachedNetworkImage(
              imageUrl: movie.posterUrl,
              width: 70,
              height: 105,
              fit: BoxFit.cover,
              placeholder: (_, _) => _shimmer(),
              errorWidget: (_, _, _) => _emptyPoster(),
            ),
    );
  }

  Widget _shimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.surfaceElevated,
      child: Container(
        width: 70,
        height: 105,
        color: AppColors.surface,
      ),
    );
  }

  Widget _emptyPoster() {
    return Container(
      width: 70,
      height: 105,
      color: AppColors.surface,
      alignment: Alignment.center,
      child: const Icon(Icons.movie_outlined,
          color: AppColors.textTertiary, size: 24),
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
        Row(
          children: [
            const Icon(Icons.star_rounded,
                size: 14, color: AppColors.accentGold),
            const SizedBox(width: 4),
            Text(
              movie.voteAverage.toStringAsFixed(1),
              style: AppTextStyles.rating.copyWith(fontSize: 13),
            ),
          ],
        ),
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
