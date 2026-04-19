import 'package:equatable/equatable.dart';

import '../../../../core/constants/app_constants.dart';

class CastMember extends Equatable {
  final int id;
  final String name;
  final String? character;
  final String? profilePath;
  final int order;

  const CastMember({
    required this.id,
    required this.name,
    required this.character,
    required this.profilePath,
    required this.order,
  });

  String get profileUrl => profilePath != null
      ? '$tmdbImageBaseUrl/$posterMedium$profilePath'
      : '';

  bool get hasPhoto => profilePath != null && profilePath!.isNotEmpty;

  String get initials {
    final String trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    final List<String> parts =
        trimmed.split(RegExp(r'\s+')).where((String s) => s.isNotEmpty).toList();
    if (parts.length >= 2) {
      return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
          .toUpperCase();
    }
    final String single = parts.first;
    return single.substring(0, single.length >= 2 ? 2 : 1).toUpperCase();
  }

  @override
  List<Object?> get props => [id, name, character, profilePath, order];
}
