import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weather_app/variables.dart';

class NetworkCityHelper {
  String? apiKey;
  double? latitude;
  double? longitude;
  NetworkCityHelper({
    required this.latitude,
    required this.longitude,
    required this.apiKey,
  });
  Future getData() async {
    print('getData city start');
    if (latitude == null || longitude == null) {
      return;
    }

    final http.Response response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      print(response.statusCode);
      String data = response.body;
      var dataMap = json.decode(data);
      return dataMap;
    } else {
      print(response.statusCode);
    }
    print('getData city end');
  }
}

class NetworkWeatherHelper {
  late double latitude;
  late double longitude;
  NetworkWeatherHelper({
    required this.latitude,
    required this.longitude,
  });
  Future getData() async {
    print('getData weather start');
    if (latitude == null || longitude == null) {
      return;
    }
    final http.Response response = await http.get(Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current=temperature_2m,relative_humidity_2m,apparent_temperature,is_day,rain,weather_code,wind_speed_10m&hourly=temperature_2m,visibility&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset,uv_index_max&temperature_unit=${(activeUnit == ActiveUnit.celsius) ? 'celsius' : 'fahrenheit'}&wind_speed_unit=ms&timeformat=unixtime&timezone=auto&past_days=7&forecast_days=8'));
    if (response.statusCode == 200) {
      print(response.statusCode);
      String data = response.body;
      var dataMap = json.decode(data);
      return dataMap;
    } else {
      print(response.statusCode);
    }
    print('getData weather end');
  }
}
