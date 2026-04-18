import 'package:equatable/equatable.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

final class HomeStarted extends HomeEvent {
  const HomeStarted();
}

final class HomeTrendingRequested extends HomeEvent {
  const HomeTrendingRequested();
}

final class HomePopularRequested extends HomeEvent {
  const HomePopularRequested();
}

final class HomeTopRatedRequested extends HomeEvent {
  const HomeTopRatedRequested();
}

final class HomeGenresRequested extends HomeEvent {
  const HomeGenresRequested();
}

final class HomeRefreshed extends HomeEvent {
  const HomeRefreshed();
}
