import 'package:go_router/go_router.dart';

import '../../features/detail/presentation/screens/detail_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/movies_list_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/watchlist/presentation/screens/watchlist_screen.dart';
import 'glass_nav_shell.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => GlassNavShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/watchlist',
          builder: (context, state) => const WatchlistScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/movie/:id',
      builder: (context, state) => DetailScreen(
        movieId: int.parse(state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      path: '/movies/:type',
      builder: (context, state) =>
          MoviesListScreen(type: state.pathParameters['type']!),
    ),
  ],
);
