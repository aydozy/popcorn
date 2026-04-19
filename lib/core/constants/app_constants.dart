const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p';

// ** TMDB image size path segments: 'w{width}' selects a CDN-generated image at
// ** that fixed pixel width; 'original' returns the unresized source. Used when
// ** building URLs: '$tmdbImageBaseUrl/$posterMedium/$posterPath'.

const String posterSmall = 'w185';
const String posterMedium = 'w342';
const String posterLarge = 'w500';
const String backdropMedium = 'w780';
const String backdropLarge = 'w1280';
const String imageOriginal = 'original';

const String watchlistBox = 'watchlist_box';
const String settingsBox = 'settings_box';
const String genreBackdropsBox = 'genre_backdrops_box';
const String genreBackdropsKey = 'backdrops';
