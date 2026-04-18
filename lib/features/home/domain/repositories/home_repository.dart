import '../../../../core/error/failures.dart';
import '../../../../core/types/either.dart';
import '../entities/genre.dart';
import '../entities/movie.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<Movie>>> getTrending();
  Future<Either<Failure, List<Movie>>> getPopular();
  Future<Either<Failure, List<Movie>>> getTopRated();
  Future<Either<Failure, List<Genre>>> getGenres();
}
