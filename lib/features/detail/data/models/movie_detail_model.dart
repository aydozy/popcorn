import '../../../home/domain/entities/genre.dart';
import '../../domain/entities/movie_detail.dart';

class MovieDetailModel extends MovieDetail {
  const MovieDetailModel({
    required super.id,
    required super.title,
    required super.tagline,
    required super.overview,
    required super.posterPath,
    required super.backdropPath,
    required super.voteAverage,
    required super.voteCount,
    required super.popularity,
    required super.releaseDate,
    required super.runtime,
    required super.genres,
    required super.originalLanguage,
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailModel(
      id: json['id'] as int,
      title: (json['title'] as String?) ?? '',
      tagline: _nullableString(json['tagline']),
      overview: (json['overview'] as String?) ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage: ((json['vote_average'] as num?) ?? 0).toDouble(),
      voteCount: (json['vote_count'] as int?) ?? 0,
      popularity: ((json['popularity'] as num?) ?? 0).toDouble(),
      releaseDate: _parseDate(json['release_date'] as String?),
      runtime: json['runtime'] as int?,
      genres: _parseGenres(json['genres']),
      originalLanguage: json['original_language'] as String?,
    );
  }

  static DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  static String? _nullableString(dynamic value) {
    if (value is! String) return null;
    return value.isEmpty ? null : value;
  }

  static List<Genre> _parseGenres(dynamic value) {
    if (value is! List) return const [];
    return value
        .whereType<Map<String, dynamic>>()
        .map((Map<String, dynamic> g) => Genre(
              id: g['id'] as int,
              name: (g['name'] as String?) ?? '',
            ))
        .toList();
  }
}
