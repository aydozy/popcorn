import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/widgets/popcorn_button.dart';
import '../../../watchlist/presentation/bloc/watchlist_bloc.dart';
import '../../../watchlist/presentation/bloc/watchlist_event.dart';
import '../../../watchlist/presentation/bloc/watchlist_state.dart';
import '../../domain/entities/movie_detail.dart';

class DetailActions extends StatelessWidget {
  final MovieDetail movie;

  const DetailActions({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: BlocBuilder<WatchlistBloc, WatchlistState>(
        buildWhen: (WatchlistState a, WatchlistState b) =>
            a.contains(movie.id) != b.contains(movie.id),
        builder: (BuildContext context, WatchlistState state) {
          final bool added = state.contains(movie.id);
          return PopcornButton(
            // Filled gradient when saved: stronger "done" affordance than just
            // swapping a checkmark into an otherwise-identical outlined button.
            outlined: !added,
            label: added ? '✓ In your watchlist' : '+ Add to Watchlist',
            onPressed: () {
              final WatchlistBloc bloc = context.read<WatchlistBloc>();
              if (added) {
                bloc.add(WatchlistRemoved(movie.id));
              } else {
                bloc.add(WatchlistAdded(movie.toMovie()));
              }
            },
          );
        },
      ),
    );
  }
}
