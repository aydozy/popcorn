import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class PopcornButton extends StatefulWidget {
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
  State<PopcornButton> createState() => _PopcornButtonState();
}

class _PopcornButtonState extends State<PopcornButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bool outlined = widget.outlined;
    final Color labelColor =
        outlined ? AppColors.primaryRose : AppColors.textPrimary;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onPressed();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
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
            widget.label,
            style: AppTextStyles.button.copyWith(color: labelColor),
          ),
        ),
      ),
    );
  }
}
