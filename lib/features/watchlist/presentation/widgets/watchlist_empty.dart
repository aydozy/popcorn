import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_empty_state.dart';

class WatchlistEmpty extends StatelessWidget {
  const WatchlistEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppEmptyState(
      imageAsset: 'assets/images/characters/connection_popcorn.png',
      title: 'Your watchlist is empty',
      subtitle: 'Save movies you want to watch later and find them all here.',
    );
  }
}
