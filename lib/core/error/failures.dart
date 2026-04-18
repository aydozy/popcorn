import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Not found']);
}

class UnauthenticatedFailure extends Failure {
  const UnauthenticatedFailure([super.message = 'Unauthenticated']);
}

class ServerException implements Exception {
  final String? message;
  final int? statusCode;
  const ServerException([this.message, this.statusCode]);

  @override
  String toString() =>
      'ServerException${statusCode != null ? '($statusCode)' : ''}: ${message ?? ''}';
}

class NetworkException implements Exception {
  final String? message;
  const NetworkException([this.message]);

  @override
  String toString() => message ?? 'NetworkException';
}

class CacheException implements Exception {
  final String? message;
  const CacheException([this.message]);

  @override
  String toString() => message ?? 'CacheException';
}

class NotFoundException implements Exception {
  const NotFoundException();

  @override
  String toString() => 'NotFoundException';
}

class UnauthenticatedException implements Exception {
  const UnauthenticatedException();

  @override
  String toString() => 'UnauthenticatedException';
}
