import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/movie.dart';
import '../bloc/home_bloc.dart';
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
          final List<Movie> movies = _moviesFor(state);
          if (movies.isEmpty) {
            return Center(
              child: Text(
                'No movies yet',
                style: AppTextStyles.bodyMedium,
              ),
            );
          }
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
        },
      ),
    );
  }
}
