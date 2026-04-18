import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/domain/entities/movie.dart';
import '../../data/watchlist_storage.dart';
import 'watchlist_event.dart';
import 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final WatchlistStorage _storage;

  WatchlistBloc(this._storage) : super(const WatchlistState()) {
    on<WatchlistStarted>(_onStarted);
    on<WatchlistAdded>(_onAdded);
    on<WatchlistRemoved>(_onRemoved);
  }

  void _onStarted(WatchlistStarted event, Emitter<WatchlistState> emit) {
    final List<Movie> movies = _storage.loadAll();
    emit(WatchlistState(
      movies: movies,
      ids: movies.map((Movie m) => m.id).toSet(),
    ));
  }

  Future<void> _onAdded(
    WatchlistAdded event,
    Emitter<WatchlistState> emit,
  ) async {
    if (state.contains(event.movie.id)) return;
    await _storage.add(event.movie);
    emit(WatchlistState(
      movies: [event.movie, ...state.movies],
      ids: {event.movie.id, ...state.ids},
    ));
  }

  Future<void> _onRemoved(
    WatchlistRemoved event,
    Emitter<WatchlistState> emit,
  ) async {
    if (!state.contains(event.movieId)) return;
    await _storage.remove(event.movieId);
    emit(WatchlistState(
      movies: state.movies
          .where((Movie m) => m.id != event.movieId)
          .toList(),
      ids: state.ids.difference({event.movieId}),
    ));
  }
}
