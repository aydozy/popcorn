import 'package:equatable/equatable.dart';

import '../../../../core/constants/app_constants.dart';

class Movie extends Equatable {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int voteCount;
  final DateTime? releaseDate;
  final List<int> genreIds;
  final String? originalLanguage;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    required this.releaseDate,
    required this.genreIds,
    required this.originalLanguage,
  });

  String get posterUrl => posterPath != null
      ? '$tmdbImageBaseUrl/$posterMedium$posterPath'
      : '';

  String get backdropUrl => backdropPath != null
      ? '$tmdbImageBaseUrl/$backdropLarge$backdropPath'
      : '';

  String get year => releaseDate?.year.toString() ?? '';

  @override
  List<Object?> get props => [
        id,
        title,
        overview,
        posterPath,
        backdropPath,
        voteAverage,
        voteCount,
        releaseDate,
        genreIds,
        originalLanguage,
      ];
}
