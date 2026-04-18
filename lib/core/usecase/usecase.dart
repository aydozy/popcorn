import 'package:equatable/equatable.dart';

import '../error/failures.dart';
import '../types/either.dart';

abstract class UseCase<Success, Params> {
  Future<Either<Failure, Success>> call(Params params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
