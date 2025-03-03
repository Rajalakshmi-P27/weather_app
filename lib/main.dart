import 'package:flutter/material.dart';
import 'package:weather_app/weather_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // Remove the debug banner on top right corner.
      theme: ThemeData.dark(
          useMaterial3: true), // set the whole theme to dark mode.
      home: const WeatherScreen(),
    );
  }
}
