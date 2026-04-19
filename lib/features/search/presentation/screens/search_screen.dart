import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../widgets/active_filter_chip.dart';
import '../widgets/genre_grid.dart';
import '../widgets/search_app_bar.dart';
import '../widgets/search_results_list.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (_) => getIt<SearchBloc>()
        ..add(const SearchGenreBackdropsRequested()),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatelessWidget {
  const _SearchView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (BuildContext context, SearchState state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SearchAppBar(),
              if (state.activeGenre != null)
                ActiveFilterChip(genre: state.activeGenre!),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 240),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.02),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: KeyedSubtree(
                    // Using mode as key so only idle↔results transitions
                    // animate — within-results state changes (loading→success)
                    // update in place instead of replaying the slide.
                    key: ValueKey<SearchMode>(
                      state.mode == SearchMode.idle
                          ? SearchMode.idle
                          : SearchMode.typing,
                    ),
                    child: state.mode == SearchMode.idle
                        ? GenreGrid(
                            backdrops: state.genreBackdrops,
                            backdropsStatus: state.backdropsStatus,
                          )
                        : SearchResultsList(state: state),
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
