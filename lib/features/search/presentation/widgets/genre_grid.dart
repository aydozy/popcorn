import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../domain/entities/genre_category.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import 'genre_card.dart';

class GenreGrid extends StatelessWidget {
  final Map<int, String> backdrops;
  final MovieStatus backdropsStatus;

  const GenreGrid({
    required this.backdrops,
    required this.backdropsStatus,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
        ),
        itemCount: MovieGenres.all.length,
        itemBuilder: (BuildContext context, int index) {
          final GenreCategory genre = MovieGenres.all[index];
          return AnimationConfiguration.staggeredGrid(
            position: index,
            columnCount: 2,
            duration: const Duration(milliseconds: 400),
            child: ScaleAnimation(
              scale: 0.9,
              child: FadeInAnimation(
                child: GenreCard(
                  genre: genre,
                  backdropPath: backdrops[genre.tmdbId],
                  loading: backdropsStatus == MovieStatus.loading ||
        backdropsStatus == MovieStatus.initial,
                  onTap: () => context
                      .read<SearchBloc>()
                      .add(SearchGenreSelected(genre)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
