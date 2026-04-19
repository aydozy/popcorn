import '../../../../core/error/failures.dart';
import '../../../../core/types/either.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../home/domain/entities/movie.dart';
import '../repositories/detail_repository.dart';

class GetSimilarMovies implements UseCase<List<Movie>, int> {
  final DetailRepository _repository;

  GetSimilarMovies(this._repository);

  @override
  Future<Either<Failure, List<Movie>>> call(int params) =>
      _repository.getSimilar(params);
}
