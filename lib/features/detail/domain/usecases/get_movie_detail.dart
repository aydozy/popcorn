import '../../../../core/error/failures.dart';
import '../../../../core/types/either.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/movie_detail.dart';
import '../repositories/detail_repository.dart';

class GetMovieDetail implements UseCase<MovieDetail, int> {
  final DetailRepository _repository;

  GetMovieDetail(this._repository);

  @override
  Future<Either<Failure, MovieDetail>> call(int params) =>
      _repository.getDetail(params);
}
