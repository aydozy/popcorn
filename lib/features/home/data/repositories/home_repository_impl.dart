import '../../../../core/error/failures.dart';
import '../../../../core/types/either.dart';
import '../../domain/entities/genre.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _dataSource;

  HomeRepositoryImpl(this._dataSource);

  Future<Either<Failure, List<Movie>>> _guardMovies(
    Future<List<Movie>> Function() fetch,
  ) async {
    try {
      final List<Movie> movies = await fetch();
      return Right(movies);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message ?? 'No internet connection'));
    } on UnauthenticatedException {
      return const Left(UnauthenticatedFailure());
    } on NotFoundException {
      return const Left(NotFoundFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(
        e.message ?? 'Server error',
        statusCode: e.statusCode,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getTrending() =>
      _guardMovies(_dataSource.getTrending);

  @override
  Future<Either<Failure, List<Movie>>> getPopular() =>
      _guardMovies(_dataSource.getPopular);

  @override
  Future<Either<Failure, List<Movie>>> getTopRated() =>
      _guardMovies(_dataSource.getTopRated);

  @override
  Future<Either<Failure, List<Genre>>> getGenres() async {
    try {
      final List<Genre> genres = await _dataSource.getGenres();
      return Right(genres);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message ?? 'No internet connection'));
    } on UnauthenticatedException {
      return const Left(UnauthenticatedFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(
        e.message ?? 'Server error',
        statusCode: e.statusCode,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
