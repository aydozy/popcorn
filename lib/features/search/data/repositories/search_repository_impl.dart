import 'package:hive/hive.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/guard.dart';
import '../../../../core/types/either.dart';
import '../../../home/domain/entities/movie.dart';
import '../../domain/entities/genre_category.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_datasource.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource _dataSource;

  SearchRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<Movie>>> search(String query) =>
      guard<List<Movie>>(() => _dataSource.search(query));

  @override
  Future<Either<Failure, List<Movie>>> discover(int genreId) =>
      guard<List<Movie>>(() => _dataSource.discover(genreId));

  @override
  Future<Either<Failure, Map<int, String>>> getGenreBackdrops() async {
    final Box<dynamic> box = Hive.box(genreBackdropsBox);
    final Map<int, String>? cached = _readCache(box);
    if (cached != null && cached.isNotEmpty) return Right(cached);

    return guard<Map<int, String>>(() async {
      // Sequential by design: each genre walks its top results looking for a
      // movie not yet claimed by an earlier genre. Parallel fetching would
      // need a merge step with conflict resolution and isn't worth the
      // complexity for a one-time 3–5s cost. A rare genre that can't find a
      // unique movie simply gets no backdrop — the card falls back to surface.
      final Map<int, String> assignments = <int, String>{};
      final Set<int> usedMovieIds = <int>{};

      for (final GenreCategory genre in MovieGenres.all) {
        final List<Movie> movies = await _dataSource.discover(genre.tmdbId);
        for (final Movie m in movies) {
          final String? backdrop = m.backdropPath;
          if (backdrop == null || backdrop.isEmpty) continue;
          if (usedMovieIds.contains(m.id)) continue;
          assignments[genre.tmdbId] = backdrop;
          usedMovieIds.add(m.id);
          break;
        }
      }

      if (assignments.isNotEmpty) {
        await box.put(
          genreBackdropsKey,
          <String, String>{
            for (final MapEntry<int, String> e in assignments.entries)
              e.key.toString(): e.value,
          },
        );
      }
      return assignments;
    });
  }

  Map<int, String>? _readCache(Box<dynamic> box) {
    final dynamic raw = box.get(genreBackdropsKey);
    if (raw is! Map) return null;
    final Map<int, String> out = <int, String>{};
    raw.forEach((dynamic k, dynamic v) {
      if (v is! String) return;
      if (k is int) {
        out[k] = v;
      } else if (k is String) {
        final int? id = int.tryParse(k);
        if (id != null) out[id] = v;
      }
    });
    return out.isEmpty ? null : out;
  }
}
