import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../home/domain/entities/movie.dart';
import '../../../home/presentation/widgets/movie_card.dart';
import '../bloc/detail_state.dart';

class DetailSimilarSection extends StatelessWidget {
  final MovieStatus status;
  final List<Movie> movies;

  const DetailSimilarSection({
    required this.status,
    required this.movies,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Hide section entirely on failure or empty result — it's optional content.
    if (status == MovieStatus.failure) return const SizedBox.shrink();
    if (status == MovieStatus.success && movies.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text('More like this', style: AppTextStyles.titleLarge),
        ),
        const SizedBox(height: 12),
        SizedBox(height: 240, child: _body()),
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
      itemCount: movies.length,
      separatorBuilder: (_, _) => const SizedBox(width: 12),
      itemBuilder: (BuildContext context, int index) => MovieCard(
        movie: movies[index],
        width: 110,
        height: 165,
      ),
    );
  }

  Widget _shimmerRow() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 4,
      separatorBuilder: (_, _) => const SizedBox(width: 12),
      itemBuilder: (_, _) => Shimmer.fromColors(
        baseColor: AppColors.surface,
        highlightColor: AppColors.surfaceElevated,
        child: Container(
          width: 110,
          height: 165,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
