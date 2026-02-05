import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const StatsApp());
}

class StatsApp extends StatelessWidget {
  const StatsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'StatsApp', home: MainScreen());
  }
}
