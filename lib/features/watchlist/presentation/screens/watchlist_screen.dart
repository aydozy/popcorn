import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/watchlist_bloc.dart';
import '../bloc/watchlist_state.dart';
import '../widgets/watchlist_empty.dart';
import '../widgets/watchlist_poster_card.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (BuildContext context, WatchlistState state) {
          if (state.isEmpty) {
            return const WatchlistEmpty();
          }
          return AnimationLimiter(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: AppColors.background,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  titleSpacing: 24,
                  title:
                      Text('Watchlist', style: AppTextStyles.headlineMedium),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 140),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.68,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int i) {
                        return AnimationConfiguration.staggeredGrid(
                          position: i,
                          columnCount: 2,
                          duration: const Duration(milliseconds: 320),
                          child: ScaleAnimation(
                            scale: 0.92,
                            child: FadeInAnimation(
                              child: WatchlistPosterCard(
                                movie: state.movies[i],
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: state.movies.length,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
