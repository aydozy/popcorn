import 'package:hive/hive.dart';

import '../../../core/constants/app_constants.dart';
import '../../home/data/models/movie_model.dart';
import '../../home/domain/entities/movie.dart';

class WatchlistStorage {
  Box<dynamic> get _box => Hive.box(watchlistBox);

  bool contains(int movieId) => _box.containsKey(movieId);

  Future<void> add(Movie movie) => _box.put(movie.id, _toJson(movie));

  Future<void> remove(int movieId) => _box.delete(movieId);

  List<Movie> loadAll() {
    return _box.values
        .whereType<Map<dynamic, dynamic>>()
        .map((Map<dynamic, dynamic> raw) =>
            MovieModel.fromJson(Map<String, dynamic>.from(raw)))
        .toList();
  }

  Map<String, dynamic> _toJson(Movie m) {
    return <String, dynamic>{
      'id': m.id,
      'title': m.title,
      'overview': m.overview,
      'poster_path': m.posterPath,
      'backdrop_path': m.backdropPath,
      'vote_average': m.voteAverage,
      'vote_count': m.voteCount,
      'release_date': m.releaseDate?.toIso8601String(),
      'genre_ids': m.genreIds,
      'original_language': m.originalLanguage,
    };
  }
}
