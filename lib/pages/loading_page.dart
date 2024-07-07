import 'dart:convert';
import 'dart:io';
import 'package:weather_app/services/gemini.dart';

import '../variables.dart' as variables;

import 'package:flutter/material.dart';
import 'package:weather_app/services/location.dart';
import 'package:weather_app/services/networking.dart';
import 'main_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  String _city = 'Loading...';
  double? latitude;
  double? longitude;
  double? temp;
  double? _offset;

  void getLocationData() async {
    try {
      print('Reached get Location Data');
      Location location = Location();
      await location.getCurrentLocation();
      NetworkCityHelper networkCityHelper = NetworkCityHelper(
        latitude: location.latitude,
        longitude: location.longitude,
        apiKey: variables.getApiKey(),
      );
      var cityData = await networkCityHelper.getData();

      NetworkWeatherHelper networkWeatherHelper = NetworkWeatherHelper(
        latitude: location.latitude,
        longitude: location.longitude,
      );
      var weatherData = await networkWeatherHelper.getData();

      if (weatherData != null && cityData != null) {
        setState(() {
          _city = cityData['name'];
          temp = weatherData['current']['temperature_2m'];
          _offset = weatherData['utc_offset_seconds'] / 3600;
        });
        print('City: $_city');
        print('Temperature: $temp');
        print('Offset: $_offset');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(
                cityData: cityData,
                weatherData: weatherData,
                latitude: location.latitude,
                longitude: location.longitude,
                offset: _offset!),
          ),
        );
      } else {
        print('Failed to load weather data');
      }
    } catch (e) {
      _showErrorDialog(context, 'Check your internet connection and try again');
      print('Error occurred: $e');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            message,
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                getLocationData(); // Retry the connection
              },
              child: Text('Retry'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitCircle(
              size: 60,
              color: Colors.white,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Loading user\'s weather...',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
