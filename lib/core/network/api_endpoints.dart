abstract final class ApiEndpoints {
  static const String trending = '/trending/movie/week';
  static const String popular = '/movie/popular';
  static const String topRated = '/movie/top_rated';
  static const String search = '/search/movie';

  static String movieDetail(int id) => '/movie/$id';
  static String movieCredits(int id) => '/movie/$id/credits';
  static String movieSimilar(int id) => '/movie/$id/similar';
}
