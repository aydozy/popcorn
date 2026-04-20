import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

// Circular blurred-glass back button used on top of imagery (detail backdrop,
// search app bar, etc.). Visible 48×48 so the hit target meets iOS / Material
// minimums without a separate outer SizedBox.
class GlassBackButton extends StatelessWidget {
  final VoidCallback onTap;

  const GlassBackButton({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.55),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
