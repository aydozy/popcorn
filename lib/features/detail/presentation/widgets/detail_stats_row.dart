import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/movie_detail.dart';

class DetailStatsRow extends StatelessWidget {
  final MovieDetail? movie;

  const DetailStatsRow({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ratingItem(),
          _likesItem(),
          _popularityItem(),
        ],
      ),
    );
  }

  Widget _ratingItem() {
    if (movie == null) return _shimmerItem();
    return _StatItem(
      icon: const Icon(Icons.star_rounded,
          color: AppColors.accentGold, size: 28),
      value: movie!.voteAverage.toStringAsFixed(1),
      label: 'TMDB',
    );
  }

  Widget _likesItem() {
    if (movie == null) return _shimmerItem();
    return _StatItem(
      icon: const Icon(Icons.favorite_rounded,
          color: AppColors.primaryRose, size: 28),
      value: _formatCount(movie!.voteCount),
      label: 'Likes',
    );
  }

  Widget _popularityItem() {
    if (movie == null) return _shimmerItem();
    return _StatItem(
      icon: const Icon(Icons.local_fire_department_rounded,
          color: AppColors.accentGoldLight, size: 28),
      value: movie!.popularityPercent,
      label: 'Liked it',
    );
  }

  Widget _shimmerItem() {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.surfaceElevated,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 14, color: AppColors.surface),
              const SizedBox(height: 4),
              Container(width: 28, height: 10, color: AppColors.surface),
            ],
          ),
        ],
      ),
    );
  }

  static String _formatCount(int n) {
    if (n < 1000) return n.toString();
    if (n < 1_000_000) {
      final double k = n / 1000;
      return '${k.toStringAsFixed(k < 10 ? 1 : 0)}K';
    }
    final double m = n / 1_000_000;
    return '${m.toStringAsFixed(m < 10 ? 1 : 0)}M';
  }
}

class _StatItem extends StatelessWidget {
  final Widget icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 30,
          height: 30,
          child: Center(child: icon),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: AppTextStyles.rating),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
