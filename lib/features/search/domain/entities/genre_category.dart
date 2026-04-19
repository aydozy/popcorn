import 'package:equatable/equatable.dart';

class GenreCategory extends Equatable {
  final int tmdbId;
  final String name;

  const GenreCategory({
    required this.tmdbId,
    required this.name,
  });

  @override
  List<Object?> get props => [tmdbId, name];
}

// TMDB genre IDs are stable — hardcoding avoids a startup round-trip.
// Visual identity now comes from real movie backdrops fetched once and cached
// (see `SearchRepository.getGenreBackdrops`).
abstract final class MovieGenres {
  static const List<GenreCategory> all = [
    GenreCategory(tmdbId: 28, name: 'Action'),
    GenreCategory(tmdbId: 12, name: 'Adventure'),
    GenreCategory(tmdbId: 16, name: 'Animation'),
    GenreCategory(tmdbId: 35, name: 'Comedy'),
    GenreCategory(tmdbId: 80, name: 'Crime'),
    GenreCategory(tmdbId: 99, name: 'Documentary'),
    GenreCategory(tmdbId: 18, name: 'Drama'),
    GenreCategory(tmdbId: 10751, name: 'Family'),
    GenreCategory(tmdbId: 14, name: 'Fantasy'),
    GenreCategory(tmdbId: 36, name: 'History'),
    GenreCategory(tmdbId: 27, name: 'Horror'),
    GenreCategory(tmdbId: 10402, name: 'Music'),
    GenreCategory(tmdbId: 9648, name: 'Mystery'),
    GenreCategory(tmdbId: 10749, name: 'Romance'),
    GenreCategory(tmdbId: 878, name: 'Sci-Fi'),
    GenreCategory(tmdbId: 53, name: 'Thriller'),
    GenreCategory(tmdbId: 10752, name: 'War'),
    GenreCategory(tmdbId: 37, name: 'Western'),
  ];

  static GenreCategory? byId(int tmdbId) {
    for (final GenreCategory g in all) {
      if (g.tmdbId == tmdbId) return g;
    }
    return null;
  }
}
