import '../../../../core/error/failures.dart';
import '../../../../core/types/either.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../home/domain/entities/movie.dart';
import '../repositories/search_repository.dart';

class DiscoverByGenre implements UseCase<List<Movie>, int> {
  final SearchRepository _repository;

  DiscoverByGenre(this._repository);

  @override
  Future<Either<Failure, List<Movie>>> call(int params) =>
      _repository.discover(params);
}
