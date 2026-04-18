import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class OnboardingStep extends StatefulWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final bool isCurrent;
  final Color glowColor;

  const OnboardingStep({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.isCurrent,
    required this.glowColor,
    super.key,
  });

  @override
  State<OnboardingStep> createState() => _OnboardingStepState();
}

class _OnboardingStepState extends State<OnboardingStep>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    if (widget.isCurrent) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(OnboardingStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isCurrent && widget.isCurrent) {
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double imageSize =
        min(MediaQuery.of(context).size.width * 0.85, 380);

    return FadeTransition(
      opacity: _controller,
      child: Column(
        children: [
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: widget.glowColor.withValues(alpha: 0.18),
                  blurRadius: 60,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                widget.imagePath,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 48),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              widget.title,
              style: AppTextStyles.displayMedium,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              widget.subtitle,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
          const SizedBox(height: 140),
        ],
      ),
    );
  }
}
