import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/storage/onboarding_storage.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _glowController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _titleOpacity;
  late final Animation<Offset> _titleOffset;
  late final Animation<double> _subtitleOpacity;
  late final Animation<double> _filmStripOpacity;
  late final Animation<Offset> _filmStripOffset;
  late final Animation<double> _glowAlpha;

  Timer? _navTimer;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.58, curve: Curves.easeOutBack),
      ),
    );
    _logoOpacity = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.58, curve: Curves.easeOut),
    );
    _titleOpacity = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.25, 0.67, curve: Curves.easeOut),
    );
    _titleOffset = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.25, 0.67, curve: Curves.easeOutCubic),
      ),
    );
    _subtitleOpacity = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.42, 0.75, curve: Curves.easeOut),
    );
    _filmStripOpacity = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    );
    _filmStripOffset = Tween<Offset>(
      begin: const Offset(0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    _glowAlpha = Tween<double>(begin: 0.3, end: 0.5).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _entranceController.forward();
    _glowController.repeat(reverse: true);

    _navTimer = Timer(const Duration(milliseconds: 2000), _navigate);
  }

  void _navigate() {
    if (!mounted) return;
    final bool seen = getIt<OnboardingStorage>().hasSeen();
    context.go(seen ? '/' : '/onboarding');
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _entranceController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned(
            left: -450,
            right: -450,
            bottom: -250,
            child: AnimatedBuilder(
              animation: _entranceController,
              builder: (BuildContext context, Widget? child) {
                return FadeTransition(
                  opacity: _filmStripOpacity,
                  child: SlideTransition(
                    position: _filmStripOffset,
                    child: child,
                  ),
                );
              },
              child: Transform.rotate(
                angle: -0.12,
                child: Image.asset(
                  'assets/images/splash/film_strip.png',
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: Listenable.merge(
                      [_entranceController, _glowController]),
                  builder: (BuildContext context, Widget? child) {
                    return FadeTransition(
                      opacity: _logoOpacity,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentGold.withValues(
                                  alpha: _glowAlpha.value,
                                ),
                                blurRadius: 100,
                                spreadRadius: 30,
                              ),
                              BoxShadow(
                                color: AppColors.primaryRed.withValues(
                                  alpha: _glowAlpha.value * 0.5,
                                ),
                                blurRadius: 60,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/images/splash/happy_popcorn.png',
                    width: 180,
                  ),
                ),
                const SizedBox(height: 32),
                FadeTransition(
                  opacity: _titleOpacity,
                  child: SlideTransition(
                    position: _titleOffset,
                    child: Text('Popcorn', style: AppTextStyles.displayLarge),
                  ),
                ),
                const SizedBox(height: 8),
                FadeTransition(
                  opacity: _subtitleOpacity,
                  child: Text(
                    'Find your next favorite',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
