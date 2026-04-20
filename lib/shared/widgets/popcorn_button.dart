import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'pressable_scale.dart';

class PopcornButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool outlined;

  const PopcornButton({
    required this.label,
    required this.onPressed,
    this.outlined = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Color labelColor =
        outlined ? AppColors.primaryRose : AppColors.textPrimary;

    return PressableScale(
      onTap: onPressed,
      child: Container(
        height: 56,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: outlined ? null : AppColors.primaryGradient,
          color: outlined ? Colors.transparent : null,
          borderRadius: BorderRadius.circular(28),
          border: outlined
              ? Border.all(color: AppColors.primaryRose, width: 1.5)
              : null,
          boxShadow: outlined
              ? null
              : [
                  BoxShadow(
                    color: AppColors.shadowCinema,
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Text(
          label,
          style: AppTextStyles.button.copyWith(color: labelColor),
        ),
      ),
    );
  }
}
