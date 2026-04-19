import 'package:equatable/equatable.dart';

import '../../../home/domain/entities/movie.dart';
import '../../../home/presentation/bloc/home_state.dart' show MovieStatus;
import '../../domain/entities/genre_category.dart';

export '../../../home/presentation/bloc/home_state.dart' show MovieStatus;

enum SearchMode { idle, typing, genreFiltered }

final class SearchState extends Equatable {
  final SearchMode mode;
  final String query;
  final GenreCategory? activeGenre;
  final MovieStatus resultsStatus;
  final List<Movie> results;
  final String? errorMessage;

  final MovieStatus backdropsStatus;
  final Map<int, String> genreBackdrops;

  const SearchState({
    this.mode = SearchMode.idle,
    this.query = '',
    this.activeGenre,
    this.resultsStatus = MovieStatus.initial,
    this.results = const [],
    this.errorMessage,
    this.backdropsStatus = MovieStatus.initial,
    this.genreBackdrops = const {},
  });

  SearchState copyWith({
    SearchMode? mode,
    String? query,
    GenreCategory? activeGenre,
    bool clearActiveGenre = false,
    MovieStatus? resultsStatus,
    List<Movie>? results,
    String? errorMessage,
    MovieStatus? backdropsStatus,
    Map<int, String>? genreBackdrops,
  }) {
    return SearchState(
      mode: mode ?? this.mode,
      query: query ?? this.query,
      activeGenre:
          clearActiveGenre ? null : (activeGenre ?? this.activeGenre),
      resultsStatus: resultsStatus ?? this.resultsStatus,
      results: results ?? this.results,
      errorMessage: errorMessage,
      backdropsStatus: backdropsStatus ?? this.backdropsStatus,
      genreBackdrops: genreBackdrops ?? this.genreBackdrops,
    );
  }

  @override
  List<Object?> get props => [
        mode,
        query,
        activeGenre,
        resultsStatus,
        results,
        errorMessage,
        backdropsStatus,
        genreBackdrops,
      ];
}
