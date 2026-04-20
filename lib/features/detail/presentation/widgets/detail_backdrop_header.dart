import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/popcorn_shimmer.dart';
import '../../domain/entities/movie_detail.dart';

class DetailBackdropHeader extends StatelessWidget {
  final MovieDetail? movie;

  const DetailBackdropHeader({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _backdrop(),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, AppColors.background],
                stops: [0.6, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _backdrop() {
    final String? url = movie?.backdropUrl;
    if (url == null || url.isEmpty) {
      return const PopcornShimmer();
    }
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (_, _) => const PopcornShimmer(),
      errorWidget: (_, _, _) =>
          const ColoredBox(color: AppColors.surface),
    );
  }
}
