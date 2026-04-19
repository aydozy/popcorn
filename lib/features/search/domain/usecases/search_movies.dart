import '../../../../core/error/failures.dart';
import '../../../../core/types/either.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../home/domain/entities/movie.dart';
import '../repositories/search_repository.dart';

class SearchMovies implements UseCase<List<Movie>, String> {
  final SearchRepository _repository;

  SearchMovies(this._repository);

  @override
  Future<Either<Failure, List<Movie>>> call(String params) =>
      _repository.search(params);
}
