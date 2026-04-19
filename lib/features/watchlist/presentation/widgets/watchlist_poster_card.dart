import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../home/domain/entities/movie.dart';
import '../bloc/watchlist_bloc.dart';
import '../bloc/watchlist_event.dart';

class WatchlistPosterCard extends StatelessWidget {
  final Movie movie;

  const WatchlistPosterCard({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${movie.title}, open details',
      child: GestureDetector(
        onTap: () => context.push('/movie/${movie.id}'),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Shared-element transition back to Detail, matching the tag used
              // by Home's MovieCard. Safe because ShellRoute swaps between Home
              // and Watchlist — only one is mounted at a time.
              Hero(
                tag: 'movie_poster_${movie.id}',
                child: _poster(),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.85),
                      ],
                    ),
                  ),
                  child: Text(
                    movie.title,
                    style: AppTextStyles.labelMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: _RemoveButton(movie: movie),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _poster() {
    if (movie.posterUrl.isEmpty) return _fallback();
    return CachedNetworkImage(
      imageUrl: movie.posterUrl,
      fit: BoxFit.cover,
      placeholder: (_, _) => Shimmer.fromColors(
        baseColor: AppColors.surface,
        highlightColor: AppColors.surfaceElevated,
        child: Container(color: AppColors.surface),
      ),
      errorWidget: (_, _, _) => _fallback(),
      fadeInDuration: const Duration(milliseconds: 200),
    );
  }

  Widget _fallback() {
    return Container(
      color: AppColors.surface,
      alignment: Alignment.center,
      child: const Icon(
        Icons.movie_outlined,
        color: AppColors.textTertiary,
        size: 40,
      ),
    );
  }
}

class _RemoveButton extends StatelessWidget {
  final Movie movie;

  const _RemoveButton({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Remove ${movie.title} from watchlist',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _remove(context),
        // Outer 44x44 hit target; visible pill sits inside with a bit of
        // breathing room so the accidental-tap window is much smaller.
        child: SizedBox(
          width: 44,
          height: 44,
          child: Center(
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.bookmark_rounded,
                color: AppColors.primaryRose,
                size: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _remove(BuildContext context) {
    HapticFeedback.lightImpact();
    context.read<WatchlistBloc>().add(WatchlistRemoved(movie.id));
  }
}
