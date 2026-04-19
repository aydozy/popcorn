import 'package:equatable/equatable.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../home/domain/entities/genre.dart';
import '../../../home/domain/entities/movie.dart';

class MovieDetail extends Equatable {
  final int id;
  final String title;
  final String? tagline;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int voteCount;
  final double popularity;
  final DateTime? releaseDate;
  final int? runtime;
  final List<Genre> genres;
  final String? originalLanguage;

  const MovieDetail({
    required this.id,
    required this.title,
    required this.tagline,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    required this.popularity,
    required this.releaseDate,
    required this.runtime,
    required this.genres,
    required this.originalLanguage,
  });

  String get posterUrl => posterPath != null
      ? '$tmdbImageBaseUrl/$posterLarge$posterPath'
      : '';

  String get backdropUrl => backdropPath != null
      ? '$tmdbImageBaseUrl/$backdropLarge$backdropPath'
      : '';

  String get year => releaseDate?.year.toString() ?? '';

  String get runtimeFormatted {
    final int? minutes = runtime;
    if (minutes == null || minutes <= 0) return '';
    final int h = minutes ~/ 60;
    final int m = minutes % 60;
    if (h == 0) return '${m}m';
    if (m == 0) return '${h}h';
    return '${h}h ${m}m';
  }

  // TMDB popularity is an unbounded positive value (typically 0–400+). We divide
  // by 4 and clamp to 100 as a rough "% liked it" proxy for the stats row.
  String get popularityPercent {
    final double normalized = (popularity / 4).clamp(0, 100);
    return '${normalized.toStringAsFixed(0)}%';
  }

  Movie toMovie() => Movie(
        id: id,
        title: title,
        overview: overview,
        posterPath: posterPath,
        backdropPath: backdropPath,
        voteAverage: voteAverage,
        voteCount: voteCount,
        releaseDate: releaseDate,
        genreIds: genres.map((Genre g) => g.id).toList(),
        originalLanguage: originalLanguage,
      );

  @override
  List<Object?> get props => [
        id,
        title,
        tagline,
        overview,
        posterPath,
        backdropPath,
        voteAverage,
        voteCount,
        popularity,
        releaseDate,
        runtime,
        genres,
        originalLanguage,
      ];
}
