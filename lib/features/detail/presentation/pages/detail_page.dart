import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final int movieId;
  const DetailPage({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
      body: Center(
        child: Text(
          'Movie #$movieId',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
