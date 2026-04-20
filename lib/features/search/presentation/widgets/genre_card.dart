import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/popcorn_shimmer.dart';
import '../../../../shared/widgets/pressable_scale.dart';
import '../../domain/entities/genre_category.dart';

class GenreCard extends StatelessWidget {
  final GenreCategory genre;
  final String? backdropPath;
  final bool loading;
  final VoidCallback onTap;

  const GenreCard({
    required this.genre,
    required this.backdropPath,
    required this.loading,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _background(),
            // Dark gradient overlay — ensures the name stays legible over
            // any backdrop, from bright daylight scenes to dark interiors.
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Color(0x4D0F172A),
                      Color(0xD90F172A),
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 14,
              child: Text(
                genre.name,
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _background() {
    final String? path = backdropPath;
    if (path != null && path.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: '$tmdbImageBaseUrl/$backdropMedium$path',
        fit: BoxFit.cover,
        placeholder: (_, _) => const PopcornShimmer(),
        errorWidget: (_, _, _) =>
            const ColoredBox(color: AppColors.surface),
        fadeInDuration: const Duration(milliseconds: 260),
      );
    }
    // First-load shimmer while the backdrops request is in flight; otherwise
    // a solid surface so the grid still reads as a full layout.
    return loading
        ? const PopcornShimmer()
        : const ColoredBox(color: AppColors.surface);
  }
}
