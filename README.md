# 🍿 Popcorn

A modern Flutter movie discovery app. Browse trending films, build a personal watchlist, and find your next favorite — powered by [TMDB](https://www.themoviedb.org/).

> 📝 **New here? Start with the API key.**
> Popcorn needs a free TMDB v4 read‑access token. I wrote a step‑by‑step guide that walks you through the whole thing, even if you haven't created the project yet:
> **[How to get a TMDB API key (even if your project doesn't exist yet)](https://medium.com/@ozyurek.aydanil/how-to-get-a-tmdb-api-key-even-if-your-project-doesnt-exist-yet-fae8845f00c6)** — Medium

**Status:** 🚧 Actively developed. Splash, onboarding, home discovery, and watchlist shipped. Detail and search are next.

---

## ✨ Screenshots

<p align="center">
  <img src="docs/screenshots/splash.png" width="220" alt="Splash screen" />
  <img src="docs/screenshots/onboarding_1.png" width="220" alt="Onboarding slide 1" />
  <img src="docs/screenshots/onboarding_2.png" width="220" alt="Onboarding slide 2" />
</p>

<p align="center">
  <img src="docs/screenshots/home.png" width="280" alt="Home — hero carousel and horizontal sections" />
  <img src="docs/screenshots/movies_list.png" width="280" alt="Movies list — 'See all' destination" />
</p>

---

## Features

- 🎬 **Discover** — Trending this week, Popular, and Top Rated sections, all from live TMDB data
- 🎠 **Hero carousel** — Swipeable top‑5 with backdrop, genre badge, rating, and smooth dot indicator
- 🔖 **Watchlist** — Add from anywhere (hero, movie card, list screen), saved locally in Hive, persists across restarts
- ✨ **Splash + Onboarding** — Animated intro for first‑time users; flag stored in Hive so returning users go straight home
- 🎨 **Premium dark UI** — Fraunces + Inter typography, cinema‑inspired palette (rose + gold), frosted‑glass bottom nav
- 📱 **Responsive layouts** — Horizontal sections, vertical poster grids, intrinsic‑height rows, no broken overflows
- 🔄 **Pull‑to‑refresh** — Re‑fetch trending/popular/top rated/genres on demand
- 🧠 **Smart caching** — App‑wide Bloc singletons keep state across navigation; no duplicate fetches

---

## Tech Stack

### Runtime
| Package | Purpose |
|---|---|
| `flutter_bloc` / `bloc` | State management (sealed events + single state per slice) |
| `go_router` | Declarative routing, `ShellRoute` for bottom nav, deep‑linking |
| `get_it` | Service locator / dependency injection |
| `dio` | HTTP with interceptors (bearer token, logging, error mapping) |
| `hive` + `hive_flutter` | Local NoSQL persistence (onboarding flag, watchlist) |
| `flutter_dotenv` | Environment variable loader |
| `cached_network_image` | Network image caching + shimmer placeholders |
| `shimmer` | Loading state placeholders |
| `equatable` | Value equality for events/states/entities |

### Dev
`build_runner`, `hive_generator`, `bloc_test`, `mocktail`

### Not used (intentionally)
- ❌ `injectable` — manual `getIt.registerLazySingleton` is readable and sufficient
- ❌ `fpdart` — we ship our own tiny sealed `Either<L, R>` in `lib/core/types/`
- ❌ `google_fonts` — Fraunces + Inter are bundled as local `.ttf` assets for smaller dependency surface

### Typography
- **[Fraunces](https://fonts.google.com/specimen/Fraunces)** — display, headlines, movie titles
- **[Inter](https://fonts.google.com/specimen/Inter)** — body text, labels, buttons

Both bundled locally under `assets/fonts/`.

---

## Architecture

Popcorn follows **Clean Architecture** pragmatically — full `data / domain / presentation` slices for feature‑heavy modules with real business logic, lightweight storage classes for simple UI/app state.

### Decision rule

> Does this feature have real domain concepts and rules?
> - **Yes** (Home, Watchlist, future Search/Detail) → full slice
> - **No** (onboarding flag, future settings flags) → single class under `lib/core/storage/`

### Layer breakdown (Home as example)

```
Domain (pure Dart)
 ├── entities/movie.dart            Movie, Genre — Equatable
 ├── repositories/home_repository.dart   abstract contract
 └── usecases/get_*.dart             UseCase<Success, Params>

Data (infrastructure)
 ├── models/movie_model.dart         extends Movie, fromJson
 ├── datasources/home_remote_datasource.dart   Dio calls
 └── repositories/home_repository_impl.dart    try/catch → Either<Failure, T>

Presentation (Flutter)
 ├── bloc/home_{event,state,bloc}.dart   sealed events, single state, MovieStatus enum per slice
 ├── screens/home_screen.dart         CustomScrollView + slivers
 └── widgets/*.dart                   HeroSection, MovieCard, MovieSection, …
```

### State management

- **Sealed events + single state.** Each feature has one `State` class with per‑slice `status` fields (`MovieStatus.initial/loading/success/failure`) — avoids state explosion.
- **App‑wide lazy singleton Blocs.** `HomeBloc` and `WatchlistBloc` are registered in `get_it` as `lazySingleton` and injected globally via `MultiBlocProvider` in `main.dart`. User returning to Home sees cached state, no re-fetch.
- **`BlocProvider.value`** — ensures BlocProvider doesn't close bloc on widget dispose (the singleton keeps living).

### Error handling

`lib/core/error/failures.dart` defines both `Failure` (for `Either`) and `Exception` subclasses:
- `ServerFailure` / `ServerException` (with status code)
- `NetworkFailure` / `NetworkException`
- `NotFoundFailure` / `NotFoundException` (404)
- `UnauthenticatedFailure` / `UnauthenticatedException` (401)
- `CacheFailure` / `CacheException`

DioClient's error interceptor maps `DioException` to these custom exceptions. Repositories `try/catch` and return `Left(ServerFailure(…))` etc.

### Routing

`go_router` with a `ShellRoute` wrapping `/` and `/watchlist` in a shared glass nav shell. Other routes (`/splash`, `/onboarding`, `/search`, `/movie/:id`, `/movies/:type`) are top‑level and render full‑screen.

```dart
initialLocation: '/splash',
ShellRoute → GlassNavShell
 ├── / → HomeScreen
 └── /watchlist → WatchlistScreen
(top-level)
 ├── /splash → SplashScreen
 ├── /onboarding → OnboardingScreen
 ├── /search → SearchScreen
 ├── /movie/:id → DetailScreen
 └── /movies/:type → MoviesListScreen   // "See all"
```

---

## Folder Structure

```
lib/
├── core/
│   ├── constants/              # Top-level const strings (URLs, Hive keys)
│   ├── di/injection.dart       # get_it wiring
│   ├── error/failures.dart     # Failure + Exception hierarchies
│   ├── network/                # DioClient, ApiEndpoints
│   ├── router/                 # GoRouter, GlassNavShell
│   ├── storage/                # Simple Hive wrappers (onboarding flag)
│   ├── theme/                  # Colors, text styles, M3 theme
│   ├── types/either.dart       # Sealed Either<L, R> + Left/Right
│   └── usecase/usecase.dart    # UseCase<Success, Params> + NoParams
│
├── features/
│   ├── splash/presentation/screens/splash_screen.dart
│   │       # Animated logo (gold/red glow), tilted film strip,
│   │       # reads onboarding flag, routes accordingly
│   │
│   ├── onboarding/
│   │   └── presentation/
│   │       ├── screens/onboarding_screen.dart    # PageView, indicator, Get Started
│   │       └── widgets/onboarding_step.dart      # Single slide with fade-in
│   │
│   ├── home/
│   │   ├── data/{datasources,models,repositories}/
│   │   ├── domain/{entities,repositories,usecases}/
│   │   └── presentation/
│   │       ├── bloc/home_{event,state,bloc}.dart
│   │       ├── screens/
│   │       │   ├── home_screen.dart               # Hero + 3 sections + grid
│   │       │   └── movies_list_screen.dart        # "See all" destination
│   │       └── widgets/
│   │           ├── home_hero_section.dart         # PageView carousel
│   │           ├── movie_card.dart                # Vertical poster card
│   │           ├── movie_list_item.dart           # Horizontal list card (New Releases)
│   │           ├── movie_section.dart             # Header + loading/error/success
│   │           └── new_releases_grid.dart
│   │
│   ├── watchlist/
│   │   ├── data/watchlist_storage.dart            # Hive wrapper
│   │   └── presentation/
│   │       ├── bloc/watchlist_{event,state,bloc}.dart
│   │       ├── screens/watchlist_screen.dart      # Poster grid + empty state
│   │       └── widgets/
│   │           ├── watchlist_poster_card.dart     # Full poster + title overlay
│   │           ├── watchlist_empty.dart           # Illustrated empty state
│   │           └── watchlist_toggle_button.dart   # Reusable add/remove pill icon
│   │
│   ├── search/   (placeholder, coming next)
│   └── detail/   (placeholder, coming next)
│
├── shared/
│   └── widgets/popcorn_button.dart                # Gradient pill CTA with tap feedback
│
└── main.dart                                      # Bootstrap: dotenv → Hive → DI → runApp
```

---

## Getting Started

### Prerequisites
- Flutter **3.10+** (Dart 3.x)
- A free TMDB v4 read‑access token — [grab one here](https://www.themoviedb.org/settings/api) or follow the [walkthrough on Medium](https://medium.com/@ozyurek.aydanil/how-to-get-a-tmdb-api-key-even-if-your-project-doesnt-exist-yet-fae8845f00c6) if it's your first time

### Setup

```bash
git clone https://github.com/<you>/popcorn.git
cd popcorn

# 1. Create your env file
cp .env.example .env

# 2. Paste your TMDB token into .env
#    TMDB_ACCESS_TOKEN=eyJhbGciOi...

# 3. Install dependencies
flutter pub get

# 4. Run
flutter run
```

### Font assets

The project uses **Fraunces** and **Inter**, bundled locally. They live at:
```
assets/fonts/fraunces/Fraunces-{Regular,SemiBold,Bold}.ttf
assets/fonts/inter/Inter-{Regular,Medium,SemiBold,Bold}.ttf
```
Files are already in the repo; no download needed.

### Environment

`.env` is **gitignored** — never commit your token. `.env.example` is the template others clone and fill in.

---

## Project Conventions

- **Screens, not Pages.** Mobile idiom: `home_screen.dart` + `HomeScreen` class, `screens/` folders.
- **Explicit types on declarations.** `final String x = …`, `for (int i = …)` — but collection literals and lambda params use inference where the target type is clear.
- **Top‑level `const`** for plain data (URLs, Hive keys).
- **`abstract final class`** for namespaced static members (`AppColors`, `AppTextStyles`, `ApiEndpoints`) — Dart 3 replacement for the old `X._()` private‑constructor trick.
- **Barrel files** (`<folder>/<folder>.dart`) at each layer for clean imports.
- **Comments explain _why_, not _what_.** Names carry the "what."

---

## Roadmap

- [x] Architectural scaffolding (DI, router, theme, error types, typography)
- [x] Splash + onboarding flow with Hive‑backed first‑run flag
- [x] Home discovery (hero carousel + 3 sections + new releases grid)
- [x] "See all" → Movies List screen
- [x] Watchlist with local persistence and toggle button everywhere
- [ ] **Detail screen** — backdrop, overview, cast, similar movies, trailer
- [ ] **Search** — real text search + genre filters via `/discover/movie`
- [ ] Pagination for Movies List (infinite scroll beyond page 1)
- [ ] Tests — Bloc unit tests with `bloc_test` + `mocktail`
- [ ] CI — GitHub Actions (`flutter analyze` + tests on PR)

---

## Credits

- Movie data & images courtesy of [The Movie Database (TMDB)](https://www.themoviedb.org/). This product uses the TMDB API but is not endorsed or certified by TMDB.
- Fonts: [Fraunces](https://fonts.google.com/specimen/Fraunces) and [Inter](https://fonts.google.com/specimen/Inter), SIL Open Font License.
- Popcorn character illustrations — custom assets.

---

## License

MIT (TBD)
