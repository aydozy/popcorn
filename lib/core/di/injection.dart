import 'package:get_it/get_it.dart';

import '../../features/home/data/datasources/home_remote_datasource.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_movie_genres.dart';
import '../../features/home/domain/usecases/get_popular_movies.dart';
import '../../features/home/domain/usecases/get_top_rated_movies.dart';
import '../../features/home/domain/usecases/get_trending_movies.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/watchlist/data/watchlist_storage.dart';
import '../../features/watchlist/presentation/bloc/watchlist_bloc.dart';
import '../../features/watchlist/presentation/bloc/watchlist_event.dart';
import '../network/dio_client.dart';
import '../storage/onboarding_storage.dart';

final GetIt getIt = GetIt.instance;

void configureDependencies() {
  // Lazy singleton: a single DioClient is shared app-wide so the connection
  // pool and interceptor config are reused; built on first access since no
  // code needs Dio before the first network request.
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  // Simple Hive-backed flag for the onboarding gate
  getIt.registerLazySingleton<OnboardingStorage>(() => OnboardingStorage());

  // Home feature graph
  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(getIt<HomeRemoteDataSource>()),
  );
  getIt.registerLazySingleton<GetTrendingMovies>(
    () => GetTrendingMovies(getIt<HomeRepository>()),
  );
  getIt.registerLazySingleton<GetPopularMovies>(
    () => GetPopularMovies(getIt<HomeRepository>()),
  );
  getIt.registerLazySingleton<GetTopRatedMovies>(
    () => GetTopRatedMovies(getIt<HomeRepository>()),
  );
  getIt.registerLazySingleton<GetMovieGenres>(
    () => GetMovieGenres(getIt<HomeRepository>()),
  );

  // HomeBloc as lazy singleton — state persists across navigation so the user
  // returning to Home sees cached data instead of re-fetching. BlocProvider
  // must use .value to avoid closing the bloc on widget dispose.
  getIt.registerLazySingleton<HomeBloc>(() => HomeBloc(
        getIt<GetTrendingMovies>(),
        getIt<GetPopularMovies>(),
        getIt<GetTopRatedMovies>(),
        getIt<GetMovieGenres>(),
      ));

  // Watchlist feature — simple Hive-backed storage + app-wide bloc.
  getIt.registerLazySingleton<WatchlistStorage>(() => WatchlistStorage());
  getIt.registerLazySingleton<WatchlistBloc>(
    () => WatchlistBloc(getIt<WatchlistStorage>())
      ..add(const WatchlistStarted()),
  );
}
