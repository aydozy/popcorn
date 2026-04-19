import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/genre_category.dart';

class GenreCard extends StatefulWidget {
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
  State<GenreCard> createState() => _GenreCardState();
}

class _GenreCardState extends State<GenreCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${widget.genre.name} genre',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onTap();
        },
        child: AnimatedScale(
          scale: _pressed ? 0.96 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
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
                    widget.genre.name,
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
        ),
      ),
    );
  }

  Widget _background() {
    final String? path = widget.backdropPath;
    if (path != null && path.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: '$tmdbImageBaseUrl/$backdropMedium$path',
        fit: BoxFit.cover,
        placeholder: (_, _) => _shimmer(),
        errorWidget: (_, _, _) => _fallback(),
        fadeInDuration: const Duration(milliseconds: 260),
      );
    }
    // First-load shimmer while the backdrops request is in flight; otherwise
    // a solid surface so the grid still reads as a full layout.
    return widget.loading ? _shimmer() : _fallback();
  }

  Widget _shimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.surfaceElevated,
      child: Container(color: AppColors.surface),
    );
  }

  Widget _fallback() {
    return Container(color: AppColors.surface);
  }
}
