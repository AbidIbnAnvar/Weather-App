import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/services/networking.dart';
import 'package:weather_app/variables.dart';

import '../components/weatherTimeButtons.dart';

class LocationPage extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String city;
  final String country;
  final Map weatherData;
  final double offset;

  const LocationPage(
      {super.key,
      required this.offset,
      required this.country,
      required this.weatherData,
      required this.city,
      required this.latitude,
      required this.longitude});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  late Map weatherDataMap;
  late double temp;
  late double feelsLike;
  late String city;
  late double windSpeed;
  late int humidity;
  late double visibility;
  late String climate;
  late int weatherCode;
  late List sunRiseData;
  late List sunSetData;
  late List visibilityData;
  bool refreshing = false;
  late bool isDay;

  Future<void> fetchData() async {
    NetworkWeatherHelper networkWeatherHelper = NetworkWeatherHelper(
        latitude: widget.latitude, longitude: widget.longitude);
    weatherDataMap = await networkWeatherHelper.getData();
  }

  void refreshUI() async {
    setState(() {
      refreshing = true;
    });

    fetchData().then((data) {
      setState(() {
        temp = weatherDataMap['current']['temperature_2m'];
        windSpeed = weatherDataMap['current']['wind_speed_10m'];
        humidity = weatherDataMap['current']['relative_humidity_2m'];
        feelsLike = weatherDataMap['current']['apparent_temperature'];
        visibilityData = weatherDataMap['hourly']['visibility'];
        weatherCode = weatherDataMap['current']['weather_code'];
        climate = climateData[weatherCode]!;
        sunRiseData = weatherDataMap['daily']['sunrise'];
        sunSetData = weatherDataMap['daily']['sunset'];
        isDay = (weatherDataMap['current']['is_day'] == 1) ? true : false;
        refreshing = false;
      });
    }).catchError((error) {
      print('Error fetching data: $error');
    });
  }

  void updateUI() {
    temp = weatherDataMap['current']['temperature_2m'];
    windSpeed = weatherDataMap['current']['wind_speed_10m'];
    humidity = weatherDataMap['current']['relative_humidity_2m'];
    feelsLike = weatherDataMap['current']['apparent_temperature'];
    visibilityData = weatherDataMap['hourly']['visibility'];
    weatherCode = weatherDataMap['current']['weather_code'];
    climate = climateData[weatherCode]!;
    sunRiseData = weatherDataMap['daily']['sunrise'];
    sunSetData = weatherDataMap['daily']['sunset'];
    isDay = (weatherDataMap['current']['is_day'] == 1) ? true : false;
  }

  String formattingDate(int value, int utcOffsetSeconds) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(value * 1000, isUtc: true);

    // Add the UTC offset

    if (utcOffsetSeconds >= 0) {
      dateTime = dateTime.add(Duration(seconds: utcOffsetSeconds));
    } else {
      dateTime = dateTime.subtract(Duration(seconds: utcOffsetSeconds * -1));
    }

    return DateFormat.jm().format(dateTime);
  }

  Column locationDetails(
      {required String detailName, required double detailValue}) {
    String value;
    String emoji;
    if (detailName == 'Wind') {
      value = '${detailValue.toStringAsFixed(1)}m/s';
      emoji = '💨';
    } else if (detailName == 'Humidity') {
      emoji = '💦';
      value = '${detailValue.round().toString()}%';
    } else {
      emoji = '🌡️';
      value = '${detailValue.round()}º';
    }
    return Column(
      children: [
        Text(
          emoji,
          style: TextStyle(fontSize: 22),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          value,
          style: TextStyle(fontSize: 18, fontFamily: 'RB Bold'),
        ),
        Text(
          detailName,
          style: (isDay)
              ? kSmallLightTextStyle.copyWith(fontSize: 12)
              : kSmallDarkTextStyle.copyWith(fontSize: 12),
        ),
      ],
    );
  }

  Column sunDetails({required String detailName, required int detailValue}) {
    String value;
    int utcOffsetTime = weatherDataMap['utc_offset_seconds'];
    String formattedTime = formattingDate(detailValue, utcOffsetTime);
    if (detailName == 'Sunrise') {
      value = '${detailValue}';
    } else {
      value = '${detailValue}';
    }
    return Column(
      children: [
        Image(
          image: AssetImage('images/${detailName.toLowerCase()}.png'),
          width: 40,
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          formattedTime,
          style: TextStyle(fontSize: 18, fontFamily: 'RB Bold'),
        ),
        Text(
          detailName,
          style: (isDay)
              ? kSmallLightTextStyle.copyWith(fontSize: 12)
              : kSmallDarkTextStyle.copyWith(fontSize: 12),
        ),
      ],
    );
  }

  Column tempDetails({required name}) {
    double value;
    if (name == 'Minimum') {
      value = weatherDataMap['daily']['temperature_2m_min'][7];
    } else {
      value = weatherDataMap['daily']['temperature_2m_max'][7];
    }
    return Column(
      children: [
        (name == 'Minimum')
            ? Icon(
                Icons.arrow_drop_down,
                color: Colors.blue,
              )
            : Icon(
                Icons.arrow_drop_up,
                color: Colors.red,
              ),
        Text(
          '${value.toStringAsFixed(1)}º',
          style: TextStyle(fontSize: 18, fontFamily: 'RB Bold'),
        ),
        Text(
          name,
          style: (isDay)
              ? kSmallLightTextStyle.copyWith(fontSize: 12)
              : kSmallDarkTextStyle.copyWith(fontSize: 12),
        ),
      ],
    );
  }

  String weatherImage(String climateDesc) {
    if (climateDesc == null || climateDesc == 'Clear') {
      climateDesc = (isDay) ? 'Day' : 'Night';
    }
    climateDesc = climateDesc.toLowerCase();
    return 'images/$climateDesc.png';
  }

  @override
  void initState() {
    super.initState();
    weatherDataMap = widget.weatherData;
    print(weatherDataMap['current']['weather_code']);
    updateUI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (isDay) ? dayTimeColor1 : nightTimeColor1,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: (isDay)
                    ? [dayTimeColor1, dayTimeColor2]
                    : [nightTimeColor1, nightTimeColor2],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          padding: EdgeInsets.only(top: 8, left: 8, right: 8),
          child: Column(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      RawMaterialButton(
                        constraints: const BoxConstraints.tightFor(
                            width: 40, height: 40),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        fillColor: (isDay) ? dayWidgetColor : nightWidgetColor,
                        child: Icon(
                          Icons.keyboard_arrow_left_rounded,
                          // Icons.grid_view_rounded,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: Column(
                          children: [
                            Text(
                              widget.city,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: 'RB Bold'),
                            ),
                            Text(
                              widget.country,
                              textAlign: TextAlign.center,
                              style: (isDay)
                                  ? kSmallLightTextStyle
                                  : kSmallDarkTextStyle,
                            ),
                          ],
                        ),
                      )),
                      RawMaterialButton(
                        constraints: const BoxConstraints.tightFor(
                            width: 40, height: 40),
                        onPressed: () {
                          refreshUI();
                        },
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        fillColor: (isDay) ? dayWidgetColor : nightWidgetColor,
                        child: Icon(
                          Icons.refresh,
                          // Icons.grid_view_rounded,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                      visible: refreshing,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          'Refreshing...',
                          style: (isDay)
                              ? kSmallLightTextStyle.copyWith(fontSize: 12)
                              : kSmallDarkTextStyle.copyWith(fontSize: 12),
                        ),
                      ))
                ],
              ),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 0, left: 16, right: 20),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      temp.round().toString() + 'º',
                                      style: TextStyle(
                                          fontSize: 80, fontFamily: 'RB Bold'),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 0, top: 0),
                                  child: Text(
                                    climate,
                                    style: (isDay)
                                        ? kSmallLightTextStyle
                                        : kSmallDarkTextStyle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Image(
                              image: AssetImage(
                                  weatherImage(climateImage[climate]!)),
                              width: 150,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: isDay ? dayWidgetColor : nightWidgetColor,
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          locationDetails(
                              detailName: 'Wind', detailValue: windSpeed),
                          SizedBox(
                            child: VerticalDivider(
                              color: Colors.white,
                              width: 1,
                              thickness: 1,
                            ),
                          ),
                          locationDetails(
                              detailName: 'Humidity',
                              detailValue: humidity.toDouble()),
                          SizedBox(
                            child: VerticalDivider(
                              color: Colors.white,
                              width: 1,
                              thickness: 1,
                            ),
                          ),
                          locationDetails(
                              detailName: 'Feels Like', detailValue: feelsLike)
                          // locationDetails(
                          //     detailName: 'Visibility', detailValue: visibility),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: isDay ? dayWidgetColor : nightWidgetColor,
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          sunDetails(
                              detailName: 'Sunrise',
                              detailValue: sunRiseData[7]),
                          sunDetails(
                              detailName: 'Sunset', detailValue: sunSetData[7]),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: isDay ? dayWidgetColor : nightWidgetColor,
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          tempDetails(name: 'Minimum'),
                          tempDetails(name: 'Maximum'),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Color(0x00202329),
                      ),
                      padding: EdgeInsets.only(top: 12, bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WeatherTimeButtons(
                            offset: widget.offset,
                            isDay: isDay,
                            button: ActiveButton.today,
                            weatherDataMap: weatherDataMap,
                            // onTap: () {
                            //   setState(() {
                            //     active = ActiveButton.today;
                            //   });
                            // },
                          ),
                          // WeatherTimeButtons(
                          //   isDay: isDay,
                          //   button: ActiveButton.tomorrow,
                          //   onTap: () {
                          //     setState(() {
                          //       active = ActiveButton.tomorrow;
                          //     });
                          //   },
                          // ),
                          // WeatherTimeButtons(
                          //   button: ActiveButton.yesterday,
                          //   onTap: () {
                          //     setState(() {
                          //       active = ActiveButton.yesterday;
                          //     });
                          //   },
                          // ),
                          // WeatherTimeButtons(
                          //   button: ActiveButton.next7days,
                          //   onTap: () {
                          //     setState(() {
                          //       active = ActiveButton.next7days;
                          //     });
                          //   },
                          // ),
                          // WeatherTimeButtons(
                          //   button: ActiveButton.past7days,
                          //   isLast: true,
                          //   onTap: () {
                          //     setState(() {
                          //       active = ActiveButton.past7days;
                          //     });
                          //   },
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
