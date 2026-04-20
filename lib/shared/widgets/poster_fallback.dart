import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

// Shared stand-in for missing or broken movie posters. Fills its parent's
// bounds, so callers wrap with a SizedBox only when there's no outer sizing
// (e.g. a standalone fallback inside a ClipRRect). `iconSize` scales with
// the poster footprint — thumbnails get 20, full-tile posters get 40.
// `backgroundColor` defaults to `surface` but switches to `surfaceElevated`
// inside surface-colored cards so the fallback still reads.
class PosterFallback extends StatelessWidget {
  final double iconSize;
  final Color backgroundColor;

  const PosterFallback({
    this.iconSize = 32,
    this.backgroundColor = AppColors.surface,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: Center(
        child: Icon(
          Icons.movie_outlined,
          color: AppColors.textTertiary,
          size: iconSize,
        ),
      ),
    );
  }
}
