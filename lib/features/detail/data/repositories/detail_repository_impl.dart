import '../../../../core/error/failures.dart';
import '../../../../core/types/either.dart';
import '../../../home/domain/entities/movie.dart';
import '../../domain/entities/cast_member.dart';
import '../../domain/entities/movie_detail.dart';
import '../../domain/repositories/detail_repository.dart';
import '../datasources/detail_remote_datasource.dart';

class DetailRepositoryImpl implements DetailRepository {
  final DetailRemoteDataSource _dataSource;

  DetailRepositoryImpl(this._dataSource);

  // Generic version of HomeRepositoryImpl._guardMovies so the three detail
  // endpoints (each returning a different success type) don't need duplicated
  // exception-mapping bodies.
  Future<Either<Failure, T>> _guard<T>(Future<T> Function() fetch) async {
    try {
      final T value = await fetch();
      return Right(value);
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
  Future<Either<Failure, MovieDetail>> getDetail(int id) =>
      _guard<MovieDetail>(() => _dataSource.getDetail(id));

  @override
  Future<Either<Failure, List<CastMember>>> getCredits(int id) =>
      _guard<List<CastMember>>(() => _dataSource.getCredits(id));

  @override
  Future<Either<Failure, List<Movie>>> getSimilar(int id) =>
      _guard<List<Movie>>(() => _dataSource.getSimilar(id));
}
