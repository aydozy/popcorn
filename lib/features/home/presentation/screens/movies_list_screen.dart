import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/movie.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/movie_card.dart';

class MoviesListScreen extends StatelessWidget {
  final String type;
  const MoviesListScreen({required this.type, super.key});

  String _titleFor(String type) {
    switch (type) {
      case 'popular':
        return 'Popular this week';
      case 'top_rated':
        return 'Top rated';
      case 'trending':
        return 'Trending';
      case 'new_releases':
        return 'New releases';
      default:
        return 'Movies';
    }
  }

  List<Movie> _moviesFor(HomeState state) {
    switch (type) {
      case 'popular':
        return state.popularMovies;
      case 'top_rated':
        return state.topRatedMovies;
      case 'trending':
        return state.trendingMovies;
      case 'new_releases':
        return state.newReleases;
      default:
        return const [];
    }
  }

  MovieStatus _statusFor(HomeState state) {
    switch (type) {
      case 'popular':
        return state.popularStatus;
      case 'top_rated':
        return state.topRatedStatus;
      case 'trending':
      case 'new_releases':
        return state.trendingStatus;
      default:
        return MovieStatus.initial;
    }
  }

  void _retry(BuildContext context) {
    final HomeBloc bloc = context.read<HomeBloc>();
    switch (type) {
      case 'popular':
        bloc.add(const HomePopularRequested());
      case 'top_rated':
        bloc.add(const HomeTopRatedRequested());
      case 'trending':
      case 'new_releases':
        bloc.add(const HomeTrendingRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(_titleFor(type), style: AppTextStyles.titleLarge),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (BuildContext context, HomeState state) {
          final MovieStatus status = _statusFor(state);
          final List<Movie> movies = _moviesFor(state);

          switch (status) {
            case MovieStatus.initial:
            case MovieStatus.loading:
              return const _GridShimmer();
            case MovieStatus.failure:
              return _ErrorBody(onRetry: () => _retry(context));
            case MovieStatus.success:
              if (movies.isEmpty) {
                return Center(
                  child: Text(
                    'No movies yet',
                    style: AppTextStyles.bodyMedium,
                  ),
                );
              }
              return _MoviesGrid(movies: movies);
          }
        },
      ),
    );
  }
}

class _MoviesGrid extends StatelessWidget {
  final List<Movie> movies;

  const _MoviesGrid({required this.movies});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        children: [
          for (int i = 0; i < movies.length; i += 2) ...[
            if (i > 0) const SizedBox(height: 20),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: MovieCard(
                      movie: movies[i],
                      width: double.infinity,
                      height: 220,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: i + 1 < movies.length
                        ? MovieCard(
                            movie: movies[i + 1],
                            width: double.infinity,
                            height: 220,
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _GridShimmer extends StatelessWidget {
  const _GridShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      physics: const NeverScrollableScrollPhysics(),
      child: Shimmer.fromColors(
        baseColor: AppColors.surface,
        highlightColor: AppColors.surfaceElevated,
        child: Column(
          children: [
            for (int i = 0; i < 4; i++) ...[
              if (i > 0) const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _skeletonCard()),
                  const SizedBox(width: 16),
                  Expanded(child: _skeletonCard()),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _skeletonCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 220,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(height: 8),
        Container(height: 12, width: 120, color: AppColors.surface),
        const SizedBox(height: 4),
        Container(height: 10, width: 60, color: AppColors.surface),
      ],
    );
  }
}

class _ErrorBody extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorBody({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded,
                color: AppColors.textTertiary, size: 48),
            const SizedBox(height: 16),
            Text('Couldn\'t load movies', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 16),
            TextButton(
              onPressed: onRetry,
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
