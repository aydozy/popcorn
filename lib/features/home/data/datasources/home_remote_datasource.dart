import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/genre_model.dart';
import '../models/movie_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<MovieModel>> getTrending();
  Future<List<MovieModel>> getPopular();
  Future<List<MovieModel>> getTopRated();
  Future<List<GenreModel>> getGenres();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final DioClient _client;

  HomeRemoteDataSourceImpl(this._client);

  Future<List<MovieModel>> _fetchMovies(String path) async {
    final response = await _client.dio.get<Map<String, dynamic>>(path);
    final List<dynamic> results =
        (response.data?['results'] as List<dynamic>?) ?? const [];
    return results
        .whereType<Map<String, dynamic>>()
        .map(MovieModel.fromJson)
        .toList();
  }

  @override
  Future<List<MovieModel>> getTrending() => _fetchMovies(ApiEndpoints.trending);

  @override
  Future<List<MovieModel>> getPopular() => _fetchMovies(ApiEndpoints.popular);

  @override
  Future<List<MovieModel>> getTopRated() => _fetchMovies(ApiEndpoints.topRated);

  @override
  Future<List<GenreModel>> getGenres() async {
    final response =
        await _client.dio.get<Map<String, dynamic>>(ApiEndpoints.movieGenres);
    final List<dynamic> raw =
        (response.data?['genres'] as List<dynamic>?) ?? const [];
    return raw
        .whereType<Map<String, dynamic>>()
        .map(GenreModel.fromJson)
        .toList();
  }
}
