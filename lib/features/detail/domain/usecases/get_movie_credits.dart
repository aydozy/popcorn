import '../../../../core/error/failures.dart';
import '../../../../core/types/either.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/cast_member.dart';
import '../repositories/detail_repository.dart';

class GetMovieCredits implements UseCase<List<CastMember>, int> {
  final DetailRepository _repository;

  GetMovieCredits(this._repository);

  @override
  Future<Either<Failure, List<CastMember>>> call(int params) =>
      _repository.getCredits(params);
}
