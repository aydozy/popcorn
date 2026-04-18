import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/genre.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_movie_genres.dart';
import '../../domain/usecases/get_popular_movies.dart';
import '../../domain/usecases/get_top_rated_movies.dart';
import '../../domain/usecases/get_trending_movies.dart';
import '../../../../core/usecase/usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetTrendingMovies _getTrending;
  final GetPopularMovies _getPopular;
  final GetTopRatedMovies _getTopRated;
  final GetMovieGenres _getGenres;

  HomeBloc(
    this._getTrending,
    this._getPopular,
    this._getTopRated,
    this._getGenres,
  ) : super(const HomeState()) {
    on<HomeStarted>(_onStarted);
    on<HomeTrendingRequested>(_onTrendingRequested);
    on<HomePopularRequested>(_onPopularRequested);
    on<HomeTopRatedRequested>(_onTopRatedRequested);
    on<HomeGenresRequested>(_onGenresRequested);
    on<HomeRefreshed>(_onRefreshed);
  }

  void _onStarted(HomeStarted event, Emitter<HomeState> emit) {
    add(const HomeGenresRequested());
    add(const HomeTrendingRequested());
    add(const HomePopularRequested());
    add(const HomeTopRatedRequested());
  }

  Future<void> _onTrendingRequested(
    HomeTrendingRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(trendingStatus: MovieStatus.loading));
    final result = await _getTrending(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
        trendingStatus: MovieStatus.failure,
        errorMessage: failure.message,
      )),
      (List<Movie> movies) => emit(state.copyWith(
        trendingStatus: MovieStatus.success,
        trendingMovies: movies,
      )),
    );
  }

  Future<void> _onPopularRequested(
    HomePopularRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(popularStatus: MovieStatus.loading));
    final result = await _getPopular(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
        popularStatus: MovieStatus.failure,
        errorMessage: failure.message,
      )),
      (List<Movie> movies) => emit(state.copyWith(
        popularStatus: MovieStatus.success,
        popularMovies: movies,
      )),
    );
  }

  Future<void> _onTopRatedRequested(
    HomeTopRatedRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(topRatedStatus: MovieStatus.loading));
    final result = await _getTopRated(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
        topRatedStatus: MovieStatus.failure,
        errorMessage: failure.message,
      )),
      (List<Movie> movies) => emit(state.copyWith(
        topRatedStatus: MovieStatus.success,
        topRatedMovies: movies,
      )),
    );
  }

  Future<void> _onGenresRequested(
    HomeGenresRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(genresStatus: MovieStatus.loading));
    final result = await _getGenres(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(genresStatus: MovieStatus.failure)),
      (List<Genre> genres) => emit(state.copyWith(
        genresStatus: MovieStatus.success,
        genres: {for (final Genre g in genres) g.id: g.name},
      )),
    );
  }

  void _onRefreshed(HomeRefreshed event, Emitter<HomeState> emit) {
    add(const HomeGenresRequested());
    add(const HomeTrendingRequested());
    add(const HomePopularRequested());
    add(const HomeTopRatedRequested());
  }
}
