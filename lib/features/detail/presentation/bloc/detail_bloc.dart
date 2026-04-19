import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/domain/entities/movie.dart';
import '../../domain/entities/cast_member.dart';
import '../../domain/entities/movie_detail.dart';
import '../../domain/usecases/get_movie_credits.dart';
import '../../domain/usecases/get_movie_detail.dart';
import '../../domain/usecases/get_similar_movies.dart';
import 'detail_event.dart';
import 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final GetMovieDetail _getDetail;
  final GetMovieCredits _getCredits;
  final GetSimilarMovies _getSimilar;

  DetailBloc(
    this._getDetail,
    this._getCredits,
    this._getSimilar,
  ) : super(const DetailState()) {
    on<DetailStarted>(_onStarted);
    on<DetailMovieRequested>(_onMovieRequested);
    on<DetailCreditsRequested>(_onCreditsRequested);
    on<DetailSimilarRequested>(_onSimilarRequested);
    on<DetailRefreshed>(_onRefreshed);
  }

  void _onStarted(DetailStarted event, Emitter<DetailState> emit) {
    add(DetailMovieRequested(event.movieId));
    add(DetailCreditsRequested(event.movieId));
    add(DetailSimilarRequested(event.movieId));
  }

  Future<void> _onMovieRequested(
    DetailMovieRequested event,
    Emitter<DetailState> emit,
  ) async {
    emit(state.copyWith(movieStatus: MovieStatus.loading));
    final result = await _getDetail(event.movieId);
    result.fold(
      (failure) => emit(state.copyWith(
        movieStatus: MovieStatus.failure,
        errorMessage: failure.message,
      )),
      (MovieDetail movie) => emit(state.copyWith(
        movieStatus: MovieStatus.success,
        movie: movie,
      )),
    );
  }

  Future<void> _onCreditsRequested(
    DetailCreditsRequested event,
    Emitter<DetailState> emit,
  ) async {
    emit(state.copyWith(castStatus: MovieStatus.loading));
    final result = await _getCredits(event.movieId);
    result.fold(
      (failure) => emit(state.copyWith(
        castStatus: MovieStatus.failure,
        errorMessage: failure.message,
      )),
      (List<CastMember> members) => emit(state.copyWith(
        castStatus: MovieStatus.success,
        cast: members,
      )),
    );
  }

  Future<void> _onSimilarRequested(
    DetailSimilarRequested event,
    Emitter<DetailState> emit,
  ) async {
    emit(state.copyWith(similarStatus: MovieStatus.loading));
    final result = await _getSimilar(event.movieId);
    result.fold(
      (failure) => emit(state.copyWith(
        similarStatus: MovieStatus.failure,
        errorMessage: failure.message,
      )),
      (List<Movie> movies) => emit(state.copyWith(
        similarStatus: MovieStatus.success,
        similarMovies: movies,
      )),
    );
  }

  void _onRefreshed(DetailRefreshed event, Emitter<DetailState> emit) {
    add(DetailMovieRequested(event.movieId));
    add(DetailCreditsRequested(event.movieId));
    add(DetailSimilarRequested(event.movieId));
  }
}
