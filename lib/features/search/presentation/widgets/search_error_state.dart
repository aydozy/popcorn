import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_error_state.dart';

class SearchErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const SearchErrorState({
    required this.message,
    required this.onRetry,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorState.image(
      imageAsset: 'assets/images/characters/connection_popcorn.png',
      title: 'Something went wrong',
      message: message,
      onRetry: onRetry,
    );
  }
}
