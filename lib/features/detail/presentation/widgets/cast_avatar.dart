import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/cast_member.dart';

class CastAvatar extends StatelessWidget {
  final CastMember member;
  final bool highlight;

  const CastAvatar({
    required this.member,
    this.highlight = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: highlight
                  ? Border.all(color: AppColors.accentGold, width: 2)
                  : null,
            ),
            padding: EdgeInsets.all(highlight ? 3 : 0),
            child: ClipOval(
              child: member.hasPhoto
                  ? CachedNetworkImage(
                      imageUrl: member.profileUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => _fallback(),
                      errorWidget: (_, _, _) => _fallback(),
                    )
                  : _fallback(),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            member.name,
            style: AppTextStyles.labelMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (member.character != null && member.character!.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              member.character!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _fallback() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: AppColors.goldGradient,
      ),
      child: Text(
        member.initials,
        style: const TextStyle(
          fontFamily: 'Fraunces',
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.background,
        ),
      ),
    );
  }
}
