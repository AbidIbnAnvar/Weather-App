import 'dart:convert';
import 'dart:io';
import 'package:weather_app/pages/location_page.dart';
import 'package:weather_app/services/gemini.dart';

import '../variables.dart' as variables;
import 'package:flutter/material.dart';
import 'package:weather_app/services/location.dart';
import 'package:weather_app/services/networking.dart';
import 'main_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingPage2 extends StatefulWidget {
  late double? latitude;
  late double? longitude;
  final String city;
  late String? country;
  late double? offset;

  LoadingPage2({
    super.key,
    this.country,
    required this.city,
    this.latitude,
    this.longitude,
    this.offset,
  });

  @override
  State<LoadingPage2> createState() => _LoadingPage2State();
}

class _LoadingPage2State extends State<LoadingPage2> {
  String _city = 'Loading...';
  double? temp;

  void getLocationData() async {
    try {
      print('Reached get Location Data');
      NetworkWeatherHelper networkWeatherHelper = NetworkWeatherHelper(
        latitude: widget.latitude!,
        longitude: widget.longitude!,
      );
      var weatherData = await networkWeatherHelper.getData();

      if (weatherData != null) {
        setState(() {
          _city = widget.city;
          temp = weatherData['current']['temperature_2m'];
        });
        print('City: $_city');
        print('Temperature: $temp');
        print('${widget.latitude},${widget.longitude}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => LocationPage(
                  offset: widget.offset!,
                  country: widget.country!,
                  weatherData: weatherData,
                  city: _city,
                  latitude: widget.latitude!,
                  longitude: widget.longitude!)),
        );
      } else {
        print('Failed to load weather data');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  void getGeminiData() async {
    try {
      Gemini gemini = Gemini();
      Map geminiDataMap = await gemini.generateResponse(
          '${widget.city}\'s information (return as json)(keys=\'utc_offset\',\'latitude\',\'longitude\',\'country\')(values=double/decimal,double/decimal,double/decimal,string)');
      widget.latitude = geminiDataMap['latitude'];
      widget.longitude = geminiDataMap['longitude'];
      widget.offset = geminiDataMap['utc_offset'];
      widget.country = geminiDataMap['country'];
      print(widget.latitude);
      print(widget.longitude);
      print(widget.offset);
      print(widget.country);
      getLocationData();
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.offset == null) {
      getGeminiData();
    } else {
      getLocationData();
    }
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
              'Loading ${widget.city}\'s weather...',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
