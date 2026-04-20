import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_error_state.dart';
import '../../../../shared/widgets/glass_back_button.dart';
import '../bloc/detail_bloc.dart';
import '../bloc/detail_event.dart';
import '../bloc/detail_state.dart';
import '../widgets/detail_actions.dart';
import '../widgets/detail_backdrop_header.dart';
import '../widgets/detail_cast_section.dart';
import '../widgets/detail_genres.dart';
import '../widgets/detail_overview.dart';
import '../widgets/detail_poster_title.dart';
import '../widgets/detail_similar_section.dart';
import '../widgets/detail_stats_row.dart';

class DetailScreen extends StatelessWidget {
  final int movieId;

  const DetailScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DetailBloc>(
      create: (_) => getIt<DetailBloc>()..add(DetailStarted(movieId)),
      child: _DetailView(movieId: movieId),
    );
  }
}

class _DetailView extends StatelessWidget {
  final int movieId;

  const _DetailView({required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<DetailBloc, DetailState>(
        builder: (BuildContext context, DetailState state) {
          if (state.hasFullFailure) {
            return AppErrorState.icon(
              icon: Icons.theaters_outlined,
              title: 'Couldn\'t load this movie',
              message: state.errorMessage,
              onRetry: () => context
                  .read<DetailBloc>()
                  .add(DetailRefreshed(movieId)),
            );
          }

          return Stack(
            children: [
              SingleChildScrollView(
                child: Stack(
                  children: [
                    DetailBackdropHeader(movie: state.movie),
                    // Top padding == backdrop height minus desired overlap.
                    // A Stack+Padding keeps the overlap without the extra
                    // layout extent a Transform.translate would leave behind
                    // at the scroll bottom.
                    Padding(
                      padding: const EdgeInsets.only(top: 160),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DetailPosterTitle(movie: state.movie),
                          const SizedBox(height: 20),
                          DetailStatsRow(movie: state.movie),
                          if (state.isMovieReady) ...[
                            const SizedBox(height: 24),
                            DetailActions(movie: state.movie!),
                            const SizedBox(height: 24),
                            DetailOverview(overview: state.movie!.overview),
                            const SizedBox(height: 24),
                            DetailGenres(genres: state.movie!.genres),
                          ],
                          const SizedBox(height: 24),
                          DetailCastSection(
                            status: state.castStatus,
                            cast: state.cast,
                          ),
                          const SizedBox(height: 24),
                          DetailSimilarSection(
                            status: state.similarStatus,
                            movies: state.similarMovies,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).padding.bottom + 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, top: 8),
                    child: GlassBackButton(onTap: () => context.pop()),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


