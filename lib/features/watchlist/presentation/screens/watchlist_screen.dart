import 'package:flutter/material.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

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
