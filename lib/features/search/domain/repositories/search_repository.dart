import '../../../../core/error/failures.dart';
import '../../../../core/types/either.dart';
import '../../../home/domain/entities/movie.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<Movie>>> search(String query);
  Future<Either<Failure, List<Movie>>> discover(int genreId);

  /// Returns a map of genre id → backdrop path (e.g. `/abc.jpg`) for every
  /// genre in `MovieGenres.all`. Cached in Hive forever (MVP); first call
  /// fetches all genres in parallel, subsequent calls return the cache.
  /// Genres whose top movie has no backdrop are simply missing from the map.
  Future<Either<Failure, Map<int, String>>> getGenreBackdrops();
}
