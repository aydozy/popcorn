import 'package:equatable/equatable.dart';

import '../../domain/entities/genre_category.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

final class SearchQueryChanged extends SearchEvent {
  final String query;
  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

final class SearchCleared extends SearchEvent {
  const SearchCleared();
}

final class SearchGenreSelected extends SearchEvent {
  final GenreCategory genre;
  const SearchGenreSelected(this.genre);

  @override
  List<Object?> get props => [genre];
}

final class SearchGenreCleared extends SearchEvent {
  const SearchGenreCleared();
}

final class SearchGenreBackdropsRequested extends SearchEvent {
  const SearchGenreBackdropsRequested();
}
