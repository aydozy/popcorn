import 'package:go_router/go_router.dart';

import '../../features/detail/presentation/pages/detail_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/watchlist/presentation/pages/watchlist_page.dart';
import 'glass_nav_shell.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => GlassNavShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/watchlist',
          builder: (context, state) => const WatchlistPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchPage(),
    ),
    GoRoute(
      path: '/movie/:id',
      builder: (context, state) => DetailPage(
        movieId: int.parse(state.pathParameters['id']!),
      ),
    ),
  ],
);
