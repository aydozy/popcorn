import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../watchlist/presentation/bloc/watchlist_bloc.dart';
import '../../../watchlist/presentation/bloc/watchlist_event.dart';
import '../../../watchlist/presentation/bloc/watchlist_state.dart';
import '../../domain/entities/movie.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class HomeHeroSection extends StatelessWidget {
  const HomeHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (HomeState a, HomeState b) =>
          a.trendingStatus != b.trendingStatus ||
          a.trendingMovies != b.trendingMovies ||
          a.genres != b.genres,
      builder: (BuildContext context, HomeState state) {
        return SizedBox(
          height: 380,
          child: Stack(
            children: [
              const _AmbientGlow(),
              Positioned.fill(
                child: switch (state.trendingStatus) {
                  MovieStatus.loading || MovieStatus.initial => const _Shimmer(),
                  MovieStatus.failure => _Error(),
                  MovieStatus.success => _Carousel(state: state),
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// Soft radial rose glow behind the carousel — reinforces the cinematic theater
// feel without drawing attention away from the card itself.
class _AmbientGlow extends StatelessWidget {
  const _AmbientGlow();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0, -0.2),
              radius: 0.9,
              colors: [
                AppColors.primaryRose.withValues(alpha: 0.12),
                AppColors.primaryRose.withValues(alpha: 0.04),
                Colors.transparent,
              ],
              stops: const [0.0, 0.55, 1.0],
            ),
          ),
        ),
      ),
    );
  }
}

class _Carousel extends StatefulWidget {
  final HomeState state;

  const _Carousel({required this.state});

  @override
  State<_Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<_Carousel> {
  static const Duration _autoAdvanceInterval = Duration(seconds: 6);
  static const Duration _userPauseAfterTouch = Duration(seconds: 4);

  late final PageController _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.92);
    _scheduleAutoAdvance();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _scheduleAutoAdvance() {
    _timer?.cancel();
    _timer = Timer.periodic(_autoAdvanceInterval, (_) {
      if (!mounted || !_pageController.hasClients) return;
      final int count = widget.state.heroMovies.length;
      if (count <= 1) return;
      final int current = (_pageController.page ?? 0).round();
      final int next = (current + 1) % count;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 520),
        curve: Curves.easeInOut,
      );
    });
  }

  // Pause auto-advance when the user touches the carousel. Waiting a few seconds
  // after the last interaction before resuming so we don't yank the card away
  // while they're still looking.
  void _pauseOnUserInteraction() {
    _timer?.cancel();
    Future<void>.delayed(_userPauseAfterTouch, () {
      if (mounted) _scheduleAutoAdvance();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Movie> heroMovies = widget.state.heroMovies;
    if (heroMovies.isEmpty) return const SizedBox.shrink();

    return Listener(
      onPointerDown: (_) => _pauseOnUserInteraction(),
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: heroMovies.length,
            itemBuilder: (BuildContext context, int i) => _HeroCard(
              movie: heroMovies[i],
              state: widget.state,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: AnimatedBuilder(
              animation: _pageController,
              builder: (BuildContext context, Widget? child) {
                final double page = _pageController.positions.isNotEmpty
                    ? (_pageController.page ?? 0.0)
                    : 0.0;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < heroMovies.length; i++) ...[
                      if (i > 0) const SizedBox(width: 6),
                      _Dot(index: i, pageValue: page),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final int index;
  final double pageValue;

  const _Dot({required this.index, required this.pageValue});

  @override
  Widget build(BuildContext context) {
    final double distance = (pageValue - index).abs().clamp(0.0, 1.0);
    final bool active = distance < 0.5;
    return Container(
      width: 6 + (1 - distance) * 14,
      height: 6,
      decoration: BoxDecoration(
        gradient: active ? AppColors.primaryGradient : null,
        color: active ? null : AppColors.textTertiary.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final Movie movie;
  final HomeState state;

  const _HeroCard({required this.movie, required this.state});

  @override
  Widget build(BuildContext context) {
    final List<String> genreNames = state.genreNamesFor(movie);
    final String meta = [
      movie.year,
      if (genreNames.isNotEmpty) genreNames.first,
    ].where((String s) => s.isNotEmpty).join(' · ');

    // Inner horizontal padding is smaller than the 20px outer gutter so that
    // neighbor cards peek by a few pixels on each side — the viewportFraction
    // does the heavy lifting; this padding just creates visual separation
    // between adjacent cards.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.push('/movie/${movie.id}'),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (movie.backdropUrl.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: movie.backdropUrl,
                  fit: BoxFit.cover,
                  placeholder: (BuildContext context, String url) =>
                      Container(color: AppColors.surface),
                  errorWidget:
                      (BuildContext context, String url, Object error) =>
                          Container(color: AppColors.surface),
                )
              else
                Container(color: AppColors.surface),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.background.withValues(alpha: 0.3),
                        AppColors.background.withValues(alpha: 0.9),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                left: 20,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: AppColors.goldGradient,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'TRENDING NOW',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.background,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.6,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 28,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: AppTextStyles.displayMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (meta.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        meta,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimary.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _Stars(voteAverage: movie.voteAverage)),
                        _WatchlistIcon(movie: movie),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WatchlistIcon extends StatelessWidget {
  final Movie movie;

  const _WatchlistIcon({required this.movie});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistBloc, WatchlistState>(
      buildWhen: (WatchlistState a, WatchlistState b) =>
          a.contains(movie.id) != b.contains(movie.id),
      builder: (BuildContext context, WatchlistState state) {
        final bool added = state.contains(movie.id);
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            HapticFeedback.lightImpact();
            final WatchlistBloc bloc = context.read<WatchlistBloc>();
            if (added) {
              bloc.add(WatchlistRemoved(movie.id));
            } else {
              bloc.add(WatchlistAdded(movie));
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: added ? null : AppColors.primaryGradient,
              color: added ? AppColors.surfaceElevated : null,
              shape: BoxShape.circle,
              boxShadow: added
                  ? null
                  : [
                      BoxShadow(
                        color: AppColors.shadowCinema,
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Icon(
              added ? Icons.bookmark_rounded : Icons.bookmark_add_outlined,
              color: added ? AppColors.primaryRose : AppColors.textPrimary,
              size: 20,
            ),
          ),
        );
      },
    );
  }
}

class _Stars extends StatelessWidget {
  final double voteAverage;

  const _Stars({required this.voteAverage});

  @override
  Widget build(BuildContext context) {
    final double outOfFive = voteAverage / 2.0;
    return Row(
      children: [
        for (int i = 0; i < 5; i++)
          Icon(
            i < outOfFive.floor()
                ? Icons.star_rounded
                : (i < outOfFive
                    ? Icons.star_half_rounded
                    : Icons.star_outline_rounded),
            size: 18,
            color: AppColors.accentGold,
          ),
        const SizedBox(width: 8),
        Text(
          voteAverage.toStringAsFixed(1),
          style: AppTextStyles.rating.copyWith(
            color: AppColors.textPrimary.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }
}

class _Shimmer extends StatelessWidget {
  const _Shimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Shimmer.fromColors(
        baseColor: AppColors.surface,
        highlightColor: AppColors.surfaceElevated,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }
}

class _Error extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded,
                color: AppColors.textTertiary, size: 40),
            const SizedBox(height: 12),
            Text('Couldn\'t load trending', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context
                  .read<HomeBloc>()
                  .add(const HomeTrendingRequested()),
              child: Text(
                'Retry',
                style: AppTextStyles.labelMedium
                    .copyWith(color: AppColors.primaryRose),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
