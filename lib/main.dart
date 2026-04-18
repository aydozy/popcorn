import 'package:flutter/material.dart';

void main() {
  runApp(const PopcornApp());
}

class PopcornApp extends StatelessWidget {
  const PopcornApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Popcorn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            '🍿 Popcorn',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
            ),
          ),
        ),
      ),
    );
  }
}