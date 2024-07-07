import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:weather_app/components/displayWeatherTime.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/variables.dart';
import 'package:weather_app/pages/main_page.dart';

class WeatherTimeButtons extends StatefulWidget {
  final bool? isFirst;
  final bool? isLast;
  final ActiveButton button;
  final double offset;
  // final VoidCallback onLeftPress;
  // final VoidCallback onRightPress;
  final Map weatherDataMap;
  final bool isDay;

  const WeatherTimeButtons({
    super.key,
    required this.button,
    required this.isDay,
    this.isFirst,
    this.isLast,
    required this.offset,
    required this.weatherDataMap,
    // required this.onLeftPress,
    // required this.onRightPress,
  });

  @override
  State<WeatherTimeButtons> createState() => _WeatherTimeButtonsState();
}

class _WeatherTimeButtonsState extends State<WeatherTimeButtons> {
  late String currentTitle;

  void onLeftPress() {
    setState(() {
      if (currentTitle == 'Tomorrow') {
        currentTitle = 'Today';
      } else if (currentTitle == 'Today') {
        currentTitle = 'Yesterday';
      } else if (currentTitle == 'Yesterday') {
        currentTitle = 'Past 7 Days';
      } else if (currentTitle == 'Next 7 Days') {
        currentTitle = 'Tomorrow';
      }
    });
  }

  void onRightPress() {
    setState(() {
      if (currentTitle == 'Today') {
        currentTitle = 'Tomorrow';
      } else if (currentTitle == 'Tomorrow') {
        currentTitle = 'Next 7 Days';
      } else if (currentTitle == 'Yesterday') {
        currentTitle = 'Today';
      } else if (currentTitle == 'Past 7 Days') {
        currentTitle = 'Yesterday';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    currentTitle = buttonTitle[widget.button] ?? 'Today';
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RawMaterialButton(
                  constraints:
                      const BoxConstraints.tightFor(width: 40, height: 40),
                  onPressed: onLeftPress,
                  elevation: 0,
                  fillColor: (widget.isDay) ? dayWidgetColor : nightWidgetColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(
                    Icons.keyboard_arrow_left,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
                Container(
                  margin: (widget.isLast == true)
                      ? EdgeInsets.only(right: 0)
                      : EdgeInsets.only(right: 10),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    // border: Border.all(color: Colors.white, width: 0.5),
                    //color: Color(0xAA202329),
                  ),
                  child: Text(
                    currentTitle,
                    style: (widget.button == active)
                        ? kSmallDarkTextStyle.copyWith(
                            color: Colors.white, fontFamily: 'RB Bold')
                        : kSmallDarkTextStyle,
                  ),
                ),
                RawMaterialButton(
                  constraints:
                      const BoxConstraints.tightFor(width: 40, height: 40),
                  onPressed: onRightPress,
                  elevation: 0,
                  fillColor: (widget.isDay) ? dayWidgetColor : nightWidgetColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: (widget.isDay) ? dayWidgetColor : nightWidgetColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: displayWeatherTime(currentTitle, active,
                    widget.weatherDataMap, widget.isDay, widget.offset),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
