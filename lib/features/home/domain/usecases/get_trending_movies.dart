import '../../../../core/error/failures.dart';
import '../../../../core/types/either.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/movie.dart';
import '../repositories/home_repository.dart';

class GetTrendingMovies implements UseCase<List<Movie>, NoParams> {
  final HomeRepository _repository;

  GetTrendingMovies(this._repository);

  @override
  Future<Either<Failure, List<Movie>>> call(NoParams params) =>
      _repository.getTrending();
}
