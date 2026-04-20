import '../../../../core/error/failures.dart';
import '../../../../core/error/guard.dart';
import '../../../../core/types/either.dart';
import '../../domain/entities/genre.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _dataSource;

  HomeRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<Movie>>> getTrending() =>
      guard<List<Movie>>(_dataSource.getTrending);

  @override
  Future<Either<Failure, List<Movie>>> getPopular() =>
      guard<List<Movie>>(_dataSource.getPopular);

  @override
  Future<Either<Failure, List<Movie>>> getTopRated() =>
      guard<List<Movie>>(_dataSource.getTopRated);

  @override
  Future<Either<Failure, List<Genre>>> getGenres() =>
      guard<List<Genre>>(_dataSource.getGenres);
}
