import '../../../../core/error/failures.dart';
import '../../../../core/error/guard.dart';
import '../../../../core/types/either.dart';
import '../../../home/domain/entities/movie.dart';
import '../../domain/entities/cast_member.dart';
import '../../domain/entities/movie_detail.dart';
import '../../domain/repositories/detail_repository.dart';
import '../datasources/detail_remote_datasource.dart';

class DetailRepositoryImpl implements DetailRepository {
  final DetailRemoteDataSource _dataSource;

  DetailRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, MovieDetail>> getDetail(int id) =>
      guard<MovieDetail>(() => _dataSource.getDetail(id));

  @override
  Future<Either<Failure, List<CastMember>>> getCredits(int id) =>
      guard<List<CastMember>>(() => _dataSource.getCredits(id));

  @override
  Future<Either<Failure, List<Movie>>> getSimilar(int id) =>
      guard<List<Movie>>(() => _dataSource.getSimilar(id));
}
