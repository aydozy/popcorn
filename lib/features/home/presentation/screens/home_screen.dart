import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/movie.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/home_hero_section.dart';
import '../widgets/movie_card.dart';
import '../widgets/movie_section.dart';
import '../widgets/new_releases_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final HomeBloc bloc = context.read<HomeBloc>();
    if (bloc.state.trendingStatus == MovieStatus.initial) {
      bloc.add(const HomeStarted());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primaryRose,
        backgroundColor: AppColors.surface,
        onRefresh: () async {
          context.read<HomeBloc>().add(const HomeRefreshed());
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: AppColors.background,
              elevation: 0,
              scrolledUnderElevation: 0,
              titleSpacing: 24,
              title: Row(
                children: [
                  Image.asset(
                    'assets/images/splash/happy_popcorn.png',
                    width: 32,
                    height: 32,
                  ),
                  const SizedBox(width: 8),
                  Text('Popcorn', style: AppTextStyles.headlineMedium),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search_rounded,
                      color: AppColors.textPrimary, size: 24),
                  onPressed: () => context.push('/search'),
                ),
                const SizedBox(width: 8),
              ],
            ),
            const SliverToBoxAdapter(child: _Greeting()),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            const SliverToBoxAdapter(child: HomeHeroSection()),
            const SliverToBoxAdapter(child: SizedBox(height: 28)),
            SliverToBoxAdapter(
              child: BlocBuilder<HomeBloc, HomeState>(
                buildWhen: (HomeState a, HomeState b) =>
                    a.popularStatus != b.popularStatus ||
                    a.popularMovies != b.popularMovies,
                builder: (BuildContext context, HomeState state) {
                  return MovieSection(
                    title: 'Popular this week',
                    status: state.popularStatus,
                    movies: state.popularMovies,
                    onRetry: () => context
                        .read<HomeBloc>()
                        .add(const HomePopularRequested()),
                    builder: _horizontalList,
                    loadingPlaceholder: const HorizontalMovieShimmer(),
                    onSeeAllTap: () => context.push('/movies/popular'),
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 28)),
            SliverToBoxAdapter(
              child: BlocBuilder<HomeBloc, HomeState>(
                buildWhen: (HomeState a, HomeState b) =>
                    a.topRatedStatus != b.topRatedStatus ||
                    a.topRatedMovies != b.topRatedMovies,
                builder: (BuildContext context, HomeState state) {
                  return MovieSection(
                    title: 'Top rated',
                    status: state.topRatedStatus,
                    movies: state.topRatedMovies,
                    onRetry: () => context
                        .read<HomeBloc>()
                        .add(const HomeTopRatedRequested()),
                    builder: _horizontalList,
                    loadingPlaceholder: const HorizontalMovieShimmer(),
                    onSeeAllTap: () => context.push('/movies/top_rated'),
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 28)),
            SliverToBoxAdapter(
              child: BlocBuilder<HomeBloc, HomeState>(
                buildWhen: (HomeState a, HomeState b) =>
                    a.trendingStatus != b.trendingStatus ||
                    a.trendingMovies != b.trendingMovies,
                builder: (BuildContext context, HomeState state) {
                  return MovieSection(
                    title: 'New releases',
                    status: state.trendingStatus,
                    movies: state.newReleases,
                    onRetry: () => context
                        .read<HomeBloc>()
                        .add(const HomeTrendingRequested()),
                    builder: (List<Movie> movies) =>
                        NewReleasesGrid(movies: movies),
                    loadingPlaceholder: const HorizontalMovieShimmer(),
                    onSeeAllTap: () => context.push('/movies/new_releases'),
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 140)),
          ],
        ),
      ),
    );
  }

  Widget _horizontalList(List<Movie> movies) {
    return SizedBox(
      height: 260,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: movies.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (BuildContext context, int i) =>
            MovieCard(movie: movies[i]),
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting();

  @override
  Widget build(BuildContext context) {
    final String greeting = _greetingForHour(DateTime.now().hour);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting,
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'What will you watch tonight?',
            style: AppTextStyles.displayMedium,
          ),
        ],
      ),
    );
  }
}

String _greetingForHour(int hour) {
  if (hour < 6) return 'Good night 🌙';
  if (hour < 12) return 'Good morning ☀️';
  if (hour < 18) return 'Good afternoon ☁️';
  if (hour < 22) return 'Good evening 🌆';
  return 'Good night 🌙';
}
