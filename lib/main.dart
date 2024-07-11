import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/pages/loading_page.dart';
import 'package:weather_app/pages/search_page.dart';
import 'pages/main_page.dart';

Future main() async {
  try {
    await dotenv.load(fileName: ".env");
    runApp(const WeatherApp());
  } catch (e) {
    print('Error loading .env file: $e');
  }
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
