import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class GlassNavShell extends StatelessWidget {
  final Widget child;
  const GlassNavShell({super.key, required this.child});

  static const List<_NavTab> _tabs = [
    _NavTab(route: '/', icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
    _NavTab(route: '/watchlist', icon: Icons.bookmark_outline, activeIcon: Icons.bookmark, label: 'Watchlist'),
  ];

  int _indexOf(String location) {
    if (location.startsWith('/watchlist')) return 1;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    final int index = _indexOf(location);
    final double homeIndicatorInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.55),
              border: Border(
                top: BorderSide(
                  color: Colors.white.withValues(alpha: 0.06),
                  width: 0.5,
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 8,
                right: 8,
                top: 8,
                // Full system inset, not a fraction — otherwise content sits
                // under the iOS home indicator gesture zone on iPhone 14/15 Pro.
                bottom: 8 + homeIndicatorInset,
              ),
              child: Row(
                children: [
                  for (int i = 0; i < _tabs.length; i++)
                    Expanded(
                      child: _GlassTab(
                        tab: _tabs[i],
                        selected: i == index,
                        onTap: () => context.go(_tabs[i].route),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavTab {
  final String route;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavTab({
    required this.route,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class _GlassTab extends StatelessWidget {
  final _NavTab tab;
  final bool selected;
  final VoidCallback onTap;
  const _GlassTab({required this.tab, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color color = selected ? AppColors.primaryRose : AppColors.textSecondary;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
              child: Icon(
                selected ? tab.activeIcon : tab.icon,
                key: ValueKey(selected),
                size: 22,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              tab.label,
              style: AppTextStyles.labelMedium.copyWith(color: color),
            ),
            const SizedBox(height: 2),
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              width: selected ? 4 : 0,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.primaryRose,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
