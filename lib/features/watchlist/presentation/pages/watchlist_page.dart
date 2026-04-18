import 'package:flutter/material.dart';

class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Watchlist')),
      body: Center(
        child: Text(
          'Watchlist',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
