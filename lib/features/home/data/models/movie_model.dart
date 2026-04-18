import '../../domain/entities/movie.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.title,
    required super.overview,
    required super.posterPath,
    required super.backdropPath,
    required super.voteAverage,
    required super.voteCount,
    required super.releaseDate,
    required super.genreIds,
    required super.originalLanguage,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as int,
      title: (json['title'] as String?) ?? '',
      overview: (json['overview'] as String?) ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage: ((json['vote_average'] as num?) ?? 0).toDouble(),
      voteCount: (json['vote_count'] as int?) ?? 0,
      releaseDate: _parseDate(json['release_date'] as String?),
      genreIds: _parseIntList(json['genre_ids']),
      originalLanguage: json['original_language'] as String?,
    );
  }

  static DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  static List<int> _parseIntList(dynamic value) {
    if (value is! List) return const [];
    return value.whereType<int>().toList();
  }
}
