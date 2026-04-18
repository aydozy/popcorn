import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Center(
        child: Text(
          'Search',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
