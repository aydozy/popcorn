import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../home/data/models/movie_model.dart';
import '../models/cast_member_model.dart';
import '../models/movie_detail_model.dart';

abstract class DetailRemoteDataSource {
  Future<MovieDetailModel> getDetail(int id);
  Future<List<CastMemberModel>> getCredits(int id);
  Future<List<MovieModel>> getSimilar(int id);
}

class DetailRemoteDataSourceImpl implements DetailRemoteDataSource {
  static const int _castLimit = 10;

  final DioClient _client;

  DetailRemoteDataSourceImpl(this._client);

  @override
  Future<MovieDetailModel> getDetail(int id) async {
    final response = await _client.dio
        .get<Map<String, dynamic>>(ApiEndpoints.movieDetail(id));
    final Map<String, dynamic> data = response.data ?? const {};
    return MovieDetailModel.fromJson(data);
  }

  @override
  Future<List<CastMemberModel>> getCredits(int id) async {
    final response = await _client.dio
        .get<Map<String, dynamic>>(ApiEndpoints.movieCredits(id));
    final List<dynamic> cast =
        (response.data?['cast'] as List<dynamic>?) ?? const [];
    final List<CastMemberModel> parsed = cast
        .whereType<Map<String, dynamic>>()
        .map(CastMemberModel.fromJson)
        .toList()
      ..sort((CastMemberModel a, CastMemberModel b) =>
          a.order.compareTo(b.order));
    if (parsed.length > _castLimit) {
      return parsed.sublist(0, _castLimit);
    }
    return parsed;
  }

  @override
  Future<List<MovieModel>> getSimilar(int id) async {
    final response = await _client.dio
        .get<Map<String, dynamic>>(ApiEndpoints.movieSimilar(id));
    final List<dynamic> results =
        (response.data?['results'] as List<dynamic>?) ?? const [];
    return results
        .whereType<Map<String, dynamic>>()
        .map(MovieModel.fromJson)
        .toList();
  }
}
