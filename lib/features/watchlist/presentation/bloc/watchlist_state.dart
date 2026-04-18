import 'package:equatable/equatable.dart';

import '../../../home/domain/entities/movie.dart';

final class WatchlistState extends Equatable {
  final List<Movie> movies;
  final Set<int> ids;

  const WatchlistState({
    this.movies = const [],
    this.ids = const {},
  });

  bool contains(int movieId) => ids.contains(movieId);

  int get count => movies.length;

  bool get isEmpty => movies.isEmpty;

  @override
  List<Object?> get props => [movies, ids];
}
