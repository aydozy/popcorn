import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/storage/onboarding_storage.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/popcorn_button.dart';
import '../widgets/onboarding_step.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_pageListener);
  }

  void _pageListener() {
    final int? page = _pageController.page?.round();
    if (page != null && page != _currentPage) {
      setState(() => _currentPage = page);
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_pageListener);
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _complete() async {
    await getIt<OnboardingStorage>().markSeen();
    if (!mounted) return;
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              children: [
                OnboardingStep(
                  imagePath: 'assets/images/onboarding/onboarding_page1.png',
                  title: "Discover movies you'll love",
                  subtitle:
                      'Browse trending films, search thousands of titles, and save what catches your eye.',
                  isCurrent: _currentPage == 0,
                  glowColor: AppColors.accentGold,
                ),
                OnboardingStep(
                  imagePath: 'assets/images/onboarding/onboarding_page2.png',
                  title: 'Build your watchlist',
                  subtitle:
                      "Save movies to watch later. Mark what you've seen. Never forget a great recommendation.",
                  isCurrent: _currentPage == 1,
                  glowColor: AppColors.primaryRose,
                ),
              ],
            ),
            Positioned(
              left: 24,
              right: 24,
              bottom: 40,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildIndicator(),
                  const SizedBox(height: 32),
                  PopcornButton(
                    label: _currentPage == 0 ? 'Next' : 'Get Started',
                    onPressed: _currentPage == 0 ? _nextPage : _complete,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator() {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget? child) {
        final double pageValue = _pageController.positions.isNotEmpty
            ? (_pageController.page ?? 0.0)
            : 0.0;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 2; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              _buildDot(i, pageValue),
            ],
          ],
        );
      },
    );
  }

  Widget _buildDot(int index, double pageValue) {
    final double distance = (pageValue - index).abs().clamp(0.0, 1.0);
     final bool active = distance < 0.5;

    return Container(
      width: 8 + (1 - distance) * 20,
      height: 8,
      decoration: BoxDecoration(
        gradient: active ? AppColors.primaryGradient : null,
        color: active ? null : AppColors.textTertiary,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
