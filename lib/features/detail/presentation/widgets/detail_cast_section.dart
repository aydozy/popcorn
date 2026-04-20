import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/popcorn_shimmer.dart';
import '../../domain/entities/cast_member.dart';
import '../bloc/detail_state.dart';
import 'cast_avatar.dart';

class DetailCastSection extends StatelessWidget {
  final MovieStatus status;
  final List<CastMember> cast;

  const DetailCastSection({
    required this.status,
    required this.cast,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Optional content: on failure or empty result just disappear — matches the
    // similar-movies section and keeps the page from showing dead-end errors.
    if (status == MovieStatus.failure) return const SizedBox.shrink();
    if (status == MovieStatus.success && cast.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text('Cast', style: AppTextStyles.titleLarge),
        ),
        const SizedBox(height: 12),
        SizedBox(height: 156, child: _body()),
      ],
    );
  }

  Widget _body() {
    if (status != MovieStatus.success) {
      return _shimmerRow();
    }
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: cast.length,
      separatorBuilder: (_, _) => const SizedBox(width: 16),
      itemBuilder: (BuildContext context, int index) => CastAvatar(
        member: cast[index],
        highlight: index == 0,
      ),
    );
  }

  Widget _shimmerRow() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 5,
      separatorBuilder: (_, _) => const SizedBox(width: 16),
      itemBuilder: (_, _) => PopcornShimmer(
        child: SizedBox(
          width: 96,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 70,
                height: 12,
                color: AppColors.surface,
              ),
              const SizedBox(height: 4),
              Container(
                width: 50,
                height: 10,
                color: AppColors.surface,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
