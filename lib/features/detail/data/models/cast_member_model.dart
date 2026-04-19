import '../../domain/entities/cast_member.dart';

class CastMemberModel extends CastMember {
  const CastMemberModel({
    required super.id,
    required super.name,
    required super.character,
    required super.profilePath,
    required super.order,
  });

  factory CastMemberModel.fromJson(Map<String, dynamic> json) {
    return CastMemberModel(
      id: json['id'] as int,
      name: (json['name'] as String?) ?? '',
      character: _nullableString(json['character']),
      profilePath: json['profile_path'] as String?,
      order: (json['order'] as int?) ?? 0,
    );
  }

  static String? _nullableString(dynamic value) {
    if (value is! String) return null;
    return value.isEmpty ? null : value;
  }
}
