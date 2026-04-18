import 'package:equatable/equatable.dart';

import '../../domain/entities/movie.dart';

enum MovieStatus { initial, loading, success, failure }

final class HomeState extends Equatable {
  final MovieStatus trendingStatus;
  final List<Movie> trendingMovies;
  final MovieStatus popularStatus;
  final List<Movie> popularMovies;
  final MovieStatus topRatedStatus;
  final List<Movie> topRatedMovies;
  final MovieStatus genresStatus;
  final Map<int, String> genres;
  final String? errorMessage;

  const HomeState({
    this.trendingStatus = MovieStatus.initial,
    this.trendingMovies = const [],
    this.popularStatus = MovieStatus.initial,
    this.popularMovies = const [],
    this.topRatedStatus = MovieStatus.initial,
    this.topRatedMovies = const [],
    this.genresStatus = MovieStatus.initial,
    this.genres = const {},
    this.errorMessage,
  });

  Movie? get featuredMovie =>
      trendingMovies.isNotEmpty ? trendingMovies.first : null;

  List<Movie> get heroMovies => trendingMovies.take(5).toList();

  List<String> genreNamesFor(Movie movie) => movie.genreIds
      .map((int id) => genres[id])
      .whereType<String>()
      .toList();

  List<Movie> get newReleases {
    final List<Movie> sorted = [...trendingMovies];
    sorted.sort((Movie a, Movie b) {
      final DateTime? aDate = a.releaseDate;
      final DateTime? bDate = b.releaseDate;
      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;
      return bDate.compareTo(aDate);
    });
    return sorted;
  }

  HomeState copyWith({
    MovieStatus? trendingStatus,
    List<Movie>? trendingMovies,
    MovieStatus? popularStatus,
    List<Movie>? popularMovies,
    MovieStatus? topRatedStatus,
    List<Movie>? topRatedMovies,
    MovieStatus? genresStatus,
    Map<int, String>? genres,
    String? errorMessage,
  }) {
    return HomeState(
      trendingStatus: trendingStatus ?? this.trendingStatus,
      trendingMovies: trendingMovies ?? this.trendingMovies,
      popularStatus: popularStatus ?? this.popularStatus,
      popularMovies: popularMovies ?? this.popularMovies,
      topRatedStatus: topRatedStatus ?? this.topRatedStatus,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
      genresStatus: genresStatus ?? this.genresStatus,
      genres: genres ?? this.genres,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        trendingStatus,
        trendingMovies,
        popularStatus,
        popularMovies,
        topRatedStatus,
        topRatedMovies,
        genresStatus,
        genres,
        errorMessage,
      ];
}
