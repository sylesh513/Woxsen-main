import 'package:flutter/material.dart';

class AppTheme {
  final ThemeData myTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 255, 105, 105)),
  );
}
