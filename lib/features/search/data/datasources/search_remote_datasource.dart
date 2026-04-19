import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../home/data/models/movie_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<MovieModel>> search(String query);
  Future<List<MovieModel>> discover(int genreId);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final DioClient _client;

  SearchRemoteDataSourceImpl(this._client);

  @override
  Future<List<MovieModel>> search(String query) async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      ApiEndpoints.search,
      queryParameters: <String, dynamic>{
        'query': query,
        'page': 1,
      },
    );
    return _parseResults(response.data);
  }

  @override
  Future<List<MovieModel>> discover(int genreId) async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      ApiEndpoints.discover,
      queryParameters: <String, dynamic>{
        'with_genres': genreId,
        'sort_by': 'popularity.desc',
        'page': 1,
      },
    );
    return _parseResults(response.data);
  }

  List<MovieModel> _parseResults(Map<String, dynamic>? data) {
    final List<dynamic> results =
        (data?['results'] as List<dynamic>?) ?? const [];
    return results
        .whereType<Map<String, dynamic>>()
        .map(MovieModel.fromJson)
        .toList();
  }
}
