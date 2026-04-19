import 'package:equatable/equatable.dart';

sealed class DetailEvent extends Equatable {
  final int movieId;
  const DetailEvent(this.movieId);

  @override
  List<Object?> get props => [movieId];
}

final class DetailStarted extends DetailEvent {
  const DetailStarted(super.movieId);
}

final class DetailMovieRequested extends DetailEvent {
  const DetailMovieRequested(super.movieId);
}

final class DetailCreditsRequested extends DetailEvent {
  const DetailCreditsRequested(super.movieId);
}

final class DetailSimilarRequested extends DetailEvent {
  const DetailSimilarRequested(super.movieId);
}

final class DetailRefreshed extends DetailEvent {
  const DetailRefreshed(super.movieId);
}
