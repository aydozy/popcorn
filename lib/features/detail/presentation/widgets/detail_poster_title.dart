import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/movie_detail.dart';

class DetailPosterTitle extends StatelessWidget {
  final MovieDetail? movie;

  const DetailPosterTitle({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _poster(),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: _titleBlock(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _poster() {
    final int? id = movie?.id;
    final Widget image = _posterImage();
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 120,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowDefault,
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: id == null
            ? image
            : Hero(tag: 'movie_poster_$id', child: image),
      ),
    );
  }

  Widget _posterImage() {
    final String? url = movie?.posterUrl;
    if (url == null || url.isEmpty) {
      return _shimmer();
    }
    return CachedNetworkImage(
      imageUrl: url,
      width: 120,
      height: 180,
      fit: BoxFit.cover,
      placeholder: (_, _) => _shimmer(),
      errorWidget: (_, _, _) => Container(
        color: AppColors.surface,
        alignment: Alignment.center,
        child: const Icon(Icons.movie_outlined,
            color: AppColors.textTertiary, size: 32),
      ),
    );
  }

  Widget _titleBlock() {
    final MovieDetail? m = movie;
    if (m == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmerLine(width: 200, height: 24),
          const SizedBox(height: 10),
          _shimmerLine(width: 140, height: 14),
          const SizedBox(height: 12),
          _shimmerLine(width: 160, height: 18),
        ],
      );
    }

    final List<String> chips = <String>[
      if (m.year.isNotEmpty) m.year,
      if (m.runtimeFormatted.isNotEmpty) m.runtimeFormatted,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          m.title,
          style: AppTextStyles.displayMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (m.tagline != null) ...[
          const SizedBox(height: 6),
          Text(
            m.tagline!,
            style: AppTextStyles.bodyMedium.copyWith(
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (chips.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: chips.map(_metaChip).toList(),
          ),
        ],
      ],
    );
  }

  Widget _metaChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _shimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.surfaceElevated,
      child: Container(
        width: 120,
        height: 180,
        color: AppColors.surface,
      ),
    );
  }

  Widget _shimmerLine({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.surfaceElevated,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
