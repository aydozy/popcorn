import 'package:equatable/equatable.dart';

import '../../../home/domain/entities/movie.dart';
import '../../../home/presentation/bloc/home_state.dart' show MovieStatus;
import '../../domain/entities/cast_member.dart';
import '../../domain/entities/movie_detail.dart';

export '../../../home/presentation/bloc/home_state.dart' show MovieStatus;

final class DetailState extends Equatable {
  final MovieStatus movieStatus;
  final MovieDetail? movie;

  final MovieStatus castStatus;
  final List<CastMember> cast;

  final MovieStatus similarStatus;
  final List<Movie> similarMovies;

  final String? errorMessage;

  const DetailState({
    this.movieStatus = MovieStatus.initial,
    this.movie,
    this.castStatus = MovieStatus.initial,
    this.cast = const [],
    this.similarStatus = MovieStatus.initial,
    this.similarMovies = const [],
    this.errorMessage,
  });

  bool get hasFullFailure =>
      movieStatus == MovieStatus.failure &&
      castStatus == MovieStatus.failure &&
      similarStatus == MovieStatus.failure;

  bool get isMovieReady =>
      movieStatus == MovieStatus.success && movie != null;

  DetailState copyWith({
    MovieStatus? movieStatus,
    MovieDetail? movie,
    MovieStatus? castStatus,
    List<CastMember>? cast,
    MovieStatus? similarStatus,
    List<Movie>? similarMovies,
    String? errorMessage,
  }) {
    return DetailState(
      movieStatus: movieStatus ?? this.movieStatus,
      movie: movie ?? this.movie,
      castStatus: castStatus ?? this.castStatus,
      cast: cast ?? this.cast,
      similarStatus: similarStatus ?? this.similarStatus,
      similarMovies: similarMovies ?? this.similarMovies,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        movieStatus,
        movie,
        castStatus,
        cast,
        similarStatus,
        similarMovies,
        errorMessage,
      ];
}
