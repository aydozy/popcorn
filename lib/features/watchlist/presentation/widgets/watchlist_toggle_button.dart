import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../home/domain/entities/movie.dart';
import '../bloc/watchlist_bloc.dart';
import '../bloc/watchlist_event.dart';
import '../bloc/watchlist_state.dart';

class WatchlistToggleButton extends StatelessWidget {
  final Movie movie;
  final double size;

  const WatchlistToggleButton({
    required this.movie,
    this.size = 32,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistBloc, WatchlistState>(
      buildWhen: (WatchlistState a, WatchlistState b) =>
          a.contains(movie.id) != b.contains(movie.id),
      builder: (BuildContext context, WatchlistState state) {
        final bool added = state.contains(movie.id);
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            HapticFeedback.lightImpact();
            final WatchlistBloc bloc = context.read<WatchlistBloc>();
            if (added) {
              bloc.add(WatchlistRemoved(movie.id));
            } else {
              bloc.add(WatchlistAdded(movie));
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: added
                  ? AppColors.primaryRose.withValues(alpha: 0.9)
                  : Colors.black.withValues(alpha: 0.55),
              shape: BoxShape.circle,
            ),
            child: Icon(
              added ? Icons.bookmark_rounded : Icons.bookmark_add_outlined,
              color: AppColors.textPrimary,
              size: size * 0.55,
            ),
          ),
        );
      },
    );
  }
}
