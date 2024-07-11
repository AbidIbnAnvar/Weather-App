import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/services/gemini.dart';
import 'package:weather_app/services/networking.dart';
import 'dart:async';
import 'search_page.dart';
import '../variables.dart';
import 'package:weather_app/components/displayWeatherTime.dart';
import 'package:weather_app/components/weatherTimeButtons.dart';

class MainPage extends StatefulWidget {
  final dynamic cityData;
  final dynamic weatherData;
  final double longitude;
  final double latitude;
  final double offset;
  const MainPage(
      {super.key,
      required this.cityData,
      required this.weatherData,
      required this.longitude,
      required this.latitude,
      required this.offset});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
  late Map weatherDataMap;
  late Map cityDataMap;
  late bool isDay;
  bool refreshing = false;
  Gemini gemini = Gemini();
  List lifestyleTips = [];
  bool tipsLoaded = false;

  // late bool isDay;
  String todayDate() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('d MMMM, EEEE');
    return formatter.format(now);
  }

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
        city = cityDataMap['name'];
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
    city = cityDataMap['name'];
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

  String weatherImage(String climateDesc) {
    if (climateDesc == 'Clear') {
      climateDesc = (isDay) ? 'Day' : 'Night';
    }
    climateDesc = climateDesc.toLowerCase();
    return 'images/$climateDesc.png';
  }

  String formattingDate(int value) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(value * 1000);
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

    String formattedTime = formattingDate(detailValue);
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

  void getLifestyleTips() async {
    try {
      Map geminiData = await gemini.generateResponse(
          'Give me 5 lifestyle for the weather ${temp.round()}º ${activeUnit == ActiveUnit.celsius ? 'Celsius' : 'Fahrenheit'} (give single line points)(return in json/key-value format)(key=\'tips\')(value type=list of string)');
      setState(() {
        lifestyleTips = geminiData['tips'];
        tipsLoaded = true;
      });
      print(lifestyleTips);
    } catch (e) {
      print('Error while generating lifestyle tips. $e');
    }
  }

  List<Column> displayLifestyleTips() {
    List<Column> tips = [];
    int n = lifestyleTips.length;
    for (int i = 0; i < n; i++) {
      tips.add(Column(
        children: [
          Text(
            lifestyleTips[i],
            style: isDay
                ? kSmallLightTextStyle.copyWith(fontSize: 14)
                : kSmallDarkTextStyle.copyWith(fontSize: 14),
          ),
          Visibility(
            visible: (i == n - 1) ? false : true,
            child: Divider(
              height: 30,
              thickness: 0.2,
              color: Colors.white,
              indent: 8,
              endIndent: 8,
            ),
          ),
        ],
      ));
    }
    return tips;
  }

  @override
  void initState() {
    super.initState();
    weatherDataMap = widget.weatherData;
    cityDataMap = widget.cityData;
    updateUI();
    getLifestyleTips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (isDay) ? dayTimeColor1 : nightTimeColor1,
      body: SafeArea(
        child: Container(
          //color: Colors.red,
          padding: const EdgeInsets.only(top: 16, bottom: 0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: (isDay)
                    ? [dayTimeColor1, dayTimeColor2]
                    : [nightTimeColor1, nightTimeColor2],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              //AppBar
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                city,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              Text(
                                todayDate(),
                                style: (isDay)
                                    ? kSmallLightTextStyle
                                    : kSmallDarkTextStyle,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              RawMaterialButton(
                                constraints: const BoxConstraints.tightFor(
                                    width: 40, height: 40),
                                onPressed: () {
                                  setState(() {
                                    if (activeUnit == ActiveUnit.celsius) {
                                      activeUnit = ActiveUnit.fahrenheit;
                                    } else {
                                      activeUnit = ActiveUnit.celsius;
                                    }
                                  });
                                  refreshUI();
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                fillColor:
                                    (isDay) ? dayWidgetColor : nightWidgetColor,
                                elevation: 0,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: activeUnit == ActiveUnit.celsius
                                      ? Text('C',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20))
                                      : Text('F',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20)),
                                ),
                              ),
                              RawMaterialButton(
                                constraints: const BoxConstraints.tightFor(
                                    width: 40, height: 40),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SearchPage(
                                                isDay: isDay,
                                              )));
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                fillColor:
                                    (isDay) ? dayWidgetColor : nightWidgetColor,
                                elevation: 0,
                                child: Icon(
                                  Icons.search,
                                  // Icons.grid_view_rounded,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                              RawMaterialButton(
                                constraints: const BoxConstraints.tightFor(
                                    width: 40, height: 40),
                                onPressed: () {
                                  refreshUI();
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                fillColor:
                                    (isDay) ? dayWidgetColor : nightWidgetColor,
                                elevation: 0,
                                child: Icon(
                                  Icons.refresh,
                                  // Icons.grid_view_rounded,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    children: [
                      //Display
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
                                        top: 10,
                                        bottom: 0,
                                        left: 16,
                                        right: 20),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        temp.round().toString() + 'º',
                                        style: TextStyle(
                                            fontSize: 80,
                                            fontFamily: 'RB Bold'),
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
                      //QuickInfo
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (isDay) ? dayWidgetColor : nightWidgetColor,
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
                                detailName: 'Feels Like',
                                detailValue: feelsLike)
                            // locationDetails(
                            //     detailName: 'Visibility', detailValue: visibility),
                          ],
                        ),
                      ),
                      //SunRise&SunSet
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (isDay) ? dayWidgetColor : nightWidgetColor,
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
                                detailName: 'Sunset',
                                detailValue: sunSetData[7]),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (isDay) ? dayWidgetColor : nightWidgetColor,
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
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (isDay) ? dayWidgetColor : nightWidgetColor,
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 24, horizontal: 32),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Lifestyle Tips',
                                  style: (isDay)
                                      ? kSmallLightTextStyle.copyWith(
                                          fontFamily: 'RB Bold')
                                      : kSmallDarkTextStyle.copyWith(
                                          fontFamily: 'RB Bold'),
                                ),
                                (tipsLoaded == false)
                                    ? SpinKitCircle(
                                        size: 30,
                                        color: Colors.white,
                                      )
                                    : SizedBox(
                                        width: 30,
                                      ),
                                // ListView.builder(
                                //         itemCount: lifestyleTips.length,
                                //         itemBuilder: (context, index) {
                                //           final tipText = lifestyleTips[index];
                                //           return Column(
                                //             children: [
                                //               Container(
                                //                 child: Text(tipText),
                                //               )
                                //             ],
                                //           );
                                //         }),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: (tipsLoaded == false)
                                  ? Text(
                                      'Generating Lifestyle Tips...',
                                      style: (isDay)
                                          ? kSmallLightTextStyle.copyWith(
                                              fontSize: 12)
                                          : kSmallDarkTextStyle.copyWith(
                                              fontSize: 12),
                                    )
                                  : Column(
                                      children: displayLifestyleTips(),
                                    ),
                            )
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
                              isDay: isDay,
                              button: ActiveButton.today,
                              weatherDataMap: weatherDataMap,
                              offset: widget.offset,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
