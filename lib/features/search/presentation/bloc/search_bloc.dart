import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../home/domain/entities/movie.dart';
import '../../domain/usecases/discover_by_genre.dart';
import '../../domain/usecases/get_genre_backdrops.dart';
import '../../domain/usecases/search_movies.dart';
import 'search_event.dart';
import 'search_state.dart';

// Debounce + switchMap means: a burst of keystrokes collapses to one request
// after the user pauses, and if a new query lands before the previous call
// resolves, the stale one is cancelled so it can't overwrite fresh results.
EventTransformer<E> _debounce<E>(Duration duration) {
  return (Stream<E> events, EventMapper<E> mapper) =>
      events.debounce(duration).switchMap(mapper);
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMovies _searchMovies;
  final DiscoverByGenre _discoverByGenre;
  final GetGenreBackdrops _getGenreBackdrops;

  SearchBloc(
    this._searchMovies,
    this._discoverByGenre,
    this._getGenreBackdrops,
  ) : super(const SearchState()) {
    on<SearchQueryChanged>(
      _onQueryChanged,
      transformer: _debounce(const Duration(milliseconds: 400)),
    );
    on<SearchCleared>(_onCleared);
    on<SearchGenreSelected>(_onGenreSelected);
    on<SearchGenreCleared>(_onGenreCleared);
    on<SearchGenreBackdropsRequested>(_onBackdropsRequested);
  }

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final String query = event.query.trim();

    if (query.isEmpty) {
      // Preserve backdrops when falling back to idle — they're screen-scoped
      // and re-fetching would be wasteful.
      emit(state.copyWith(
        mode: SearchMode.idle,
        query: '',
        clearActiveGenre: true,
        resultsStatus: MovieStatus.initial,
        results: const [],
      ));
      return;
    }

    emit(state.copyWith(
      mode: SearchMode.typing,
      query: query,
      clearActiveGenre: true,
      resultsStatus: MovieStatus.loading,
    ));

    final result = await _searchMovies(query);
    result.fold(
      (failure) => emit(state.copyWith(
        resultsStatus: MovieStatus.failure,
        errorMessage: failure.message,
      )),
      (List<Movie> movies) => emit(state.copyWith(
        resultsStatus: MovieStatus.success,
        results: movies,
      )),
    );
  }

  void _onCleared(SearchCleared event, Emitter<SearchState> emit) {
    emit(state.copyWith(
      mode: SearchMode.idle,
      query: '',
      clearActiveGenre: true,
      resultsStatus: MovieStatus.initial,
      results: const [],
    ));
  }

  Future<void> _onGenreSelected(
    SearchGenreSelected event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(
      mode: SearchMode.genreFiltered,
      query: '',
      activeGenre: event.genre,
      resultsStatus: MovieStatus.loading,
      results: const [],
    ));

    final result = await _discoverByGenre(event.genre.tmdbId);
    result.fold(
      (failure) => emit(state.copyWith(
        resultsStatus: MovieStatus.failure,
        errorMessage: failure.message,
      )),
      (List<Movie> movies) => emit(state.copyWith(
        resultsStatus: MovieStatus.success,
        results: movies,
      )),
    );
  }

  void _onGenreCleared(SearchGenreCleared event, Emitter<SearchState> emit) {
    emit(state.copyWith(
      mode: SearchMode.idle,
      query: '',
      clearActiveGenre: true,
      resultsStatus: MovieStatus.initial,
      results: const [],
    ));
  }

  Future<void> _onBackdropsRequested(
    SearchGenreBackdropsRequested event,
    Emitter<SearchState> emit,
  ) async {
    if (state.backdropsStatus == MovieStatus.loading) return;
    if (state.genreBackdrops.isNotEmpty) return;

    emit(state.copyWith(backdropsStatus: MovieStatus.loading));
    final result = await _getGenreBackdrops(const NoParams());
    result.fold(
      // Silent failure: backdrops are a visual enhancement, not critical.
      // Cards fall back to surface color + genre name.
      (_) => emit(state.copyWith(backdropsStatus: MovieStatus.failure)),
      (Map<int, String> backdrops) => emit(state.copyWith(
        backdropsStatus: MovieStatus.success,
        genreBackdrops: backdrops,
      )),
    );
  }
}
