import 'package:flutter/material.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/pages/loading_page.dart';
import 'package:weather_app/pages/search_page.dart';
import 'pages/main_page.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
          textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontFamily: 'RB Bold',
          fontSize: 24,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'RB',
          fontSize: 20,
        ),
      )),
      home: LoadingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
