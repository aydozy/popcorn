import '../../../../core/error/failures.dart';
import '../../../../core/types/either.dart';
import '../../../home/domain/entities/movie.dart';
import '../entities/cast_member.dart';
import '../entities/movie_detail.dart';

abstract class DetailRepository {
  Future<Either<Failure, MovieDetail>> getDetail(int id);
  Future<Either<Failure, List<CastMember>>> getCredits(int id);
  Future<Either<Failure, List<Movie>>> getSimilar(int id);
}
