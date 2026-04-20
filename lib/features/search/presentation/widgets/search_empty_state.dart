import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_empty_state.dart';

class SearchEmptyState extends StatelessWidget {
  const SearchEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppEmptyState(
      imageAsset: 'assets/images/characters/problem_popcorn.png',
      title: 'Nothing found',
      subtitle: 'Try a different search or pick a genre.',
    );
  }
}
