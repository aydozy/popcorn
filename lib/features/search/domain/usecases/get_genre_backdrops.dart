import '../../../../core/error/failures.dart';
import '../../../../core/types/either.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/search_repository.dart';

class GetGenreBackdrops implements UseCase<Map<int, String>, NoParams> {
  final SearchRepository _repository;

  GetGenreBackdrops(this._repository);

  @override
  Future<Either<Failure, Map<int, String>>> call(NoParams params) =>
      _repository.getGenreBackdrops();
}
