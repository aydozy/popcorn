import 'package:equatable/equatable.dart';

import '../../../home/domain/entities/movie.dart';

sealed class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object?> get props => [];
}

final class WatchlistStarted extends WatchlistEvent {
  const WatchlistStarted();
}

final class WatchlistAdded extends WatchlistEvent {
  final Movie movie;
  const WatchlistAdded(this.movie);

  @override
  List<Object?> get props => [movie];
}

final class WatchlistRemoved extends WatchlistEvent {
  final int movieId;
  const WatchlistRemoved(this.movieId);

  @override
  List<Object?> get props => [movieId];
}
