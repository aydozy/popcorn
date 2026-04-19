import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
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
      return _shimmer();
    }
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (_, _) => _shimmer(),
      errorWidget: (_, _, _) => Container(color: AppColors.surface),
    );
  }

  Widget _shimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.surfaceElevated,
      child: Container(color: AppColors.surface),
    );
  }
}
