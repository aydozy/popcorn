import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/theme/app_colors.dart';

// App-wide shimmer wrapper so every placeholder shares the same base/highlight
// colors. Defaults to a plain surface-colored fill (covers the common case);
// pass a `child` for richer skeleton shapes (row/column of bars, circles…).
class PopcornShimmer extends StatelessWidget {
  final Widget? child;

  const PopcornShimmer({this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.surfaceElevated,
      child: child ?? const ColoredBox(color: AppColors.surface),
    );
  }
}
