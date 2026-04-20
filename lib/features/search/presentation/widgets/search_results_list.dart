import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/popcorn_shimmer.dart';
import '../../../home/domain/entities/movie.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import 'search_empty_state.dart';
import 'search_error_state.dart';
import 'search_result_item.dart';

class SearchResultsList extends StatelessWidget {
  final SearchState state;

  const SearchResultsList({required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(),
        Expanded(child: _body(context)),
      ],
    );
  }

  Widget _header() {
    late final String text;
    if (state.mode == SearchMode.typing) {
      text = 'Results for "${state.query}"';
    } else {
      final String name = state.activeGenre?.name ?? '';
      text = state.resultsStatus == MovieStatus.success
          ? '${state.results.length} $name movies'
          : '$name movies';
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        text,
        style: AppTextStyles.bodyLarge,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _body(BuildContext context) {
    switch (state.resultsStatus) {
      case MovieStatus.initial:
      case MovieStatus.loading:
        return const _ResultShimmerList();
      case MovieStatus.failure:
        return SearchErrorState(
          message: state.errorMessage ?? 'Couldn\'t load results',
          onRetry: () {
            final SearchBloc bloc = context.read<SearchBloc>();
            if (state.mode == SearchMode.typing) {
              bloc.add(SearchQueryChanged(state.query));
            } else if (state.activeGenre != null) {
              bloc.add(SearchGenreSelected(state.activeGenre!));
            }
          },
        );
      case MovieStatus.success:
        if (state.results.isEmpty) return const SearchEmptyState();
        return AnimationLimiter(
          child: ListView.separated(
            padding: const EdgeInsets.only(top: 4, bottom: 24),
            itemCount: state.results.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (BuildContext context, int index) {
              final Movie movie = state.results[index];
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 320),
                child: SlideAnimation(
                  verticalOffset: 16,
                  child: FadeInAnimation(
                    child: SearchResultItem(movie: movie),
                  ),
                ),
              );
            },
          ),
        );
    }
  }
}

class _ResultShimmerList extends StatelessWidget {
  const _ResultShimmerList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 4, bottom: 24),
      itemCount: 5,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (_, _) => const _ShimmerRow(),
    );
  }
}

class _ShimmerRow extends StatelessWidget {
  const _ShimmerRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: PopcornShimmer(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 70,
              height: 105,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: double.infinity,
                      height: 16,
                      color: AppColors.surface),
                  const SizedBox(height: 8),
                  Container(width: 120, height: 12, color: AppColors.surface),
                  const SizedBox(height: 12),
                  Container(
                      width: double.infinity,
                      height: 10,
                      color: AppColors.surface),
                  const SizedBox(height: 4),
                  Container(
                      width: double.infinity,
                      height: 10,
                      color: AppColors.surface),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
