import 'package:flutter/material.dart';

import '../../domain/entities/movie.dart';
import 'movie_list_item.dart';

class NewReleasesGrid extends StatelessWidget {
  final List<Movie> movies;
  final int maxItems;

  const NewReleasesGrid({
    required this.movies,
    this.maxItems = 8,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<Movie> visible = movies.take(maxItems).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          for (int i = 0; i < visible.length; i += 2) ...[
            if (i > 0) const SizedBox(height: 12),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: MovieListItem(movie: visible[i])),
                  const SizedBox(width: 12),
                  Expanded(
                    child: i + 1 < visible.length
                        ? MovieListItem(movie: visible[i + 1])
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
