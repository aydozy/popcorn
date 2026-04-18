sealed class Either<L, R> {
  const Either();

  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight);
}

final class Left<L, R> extends Either<L, R> {
  final L value;
  const Left(this.value);

  @override
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) => onLeft(value);
}

final class Right<L, R> extends Either<L, R> {
  final R value;
  const Right(this.value);

  @override
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) => onRight(value);
}
