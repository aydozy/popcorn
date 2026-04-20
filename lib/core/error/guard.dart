import 'failures.dart';
import '../types/either.dart';

// Wraps any async fetch in a try/catch that maps our custom Exception types to
// the matching Failure types. Every repository uses this as its data → domain
// boundary, so UI code only ever sees Either<Failure, T> — never a raw throw.
Future<Either<Failure, T>> guard<T>(Future<T> Function() fetch) async {
  try {
    final T value = await fetch();
    return Right(value);
  } on NetworkException catch (e) {
    return Left(NetworkFailure(e.message ?? 'No internet connection'));
  } on UnauthenticatedException {
    return const Left(UnauthenticatedFailure());
  } on NotFoundException {
    return const Left(NotFoundFailure());
  } on ServerException catch (e) {
    return Left(ServerFailure(
      e.message ?? 'Server error',
      statusCode: e.statusCode,
    ));
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}
