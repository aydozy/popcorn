import '../../../../core/error/failures.dart';
import '../../../../core/types/either.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/genre.dart';
import '../repositories/home_repository.dart';

class GetMovieGenres implements UseCase<List<Genre>, NoParams> {
  final HomeRepository _repository;

  GetMovieGenres(this._repository);

  @override
  Future<Either<Failure, List<Genre>>> call(NoParams params) =>
      _repository.getGenres();
}
