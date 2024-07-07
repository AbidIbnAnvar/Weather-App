import 'package:flutter/material.dart';
import 'package:weather_app/variables.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/constants.dart';

List<Container> displayWeatherTime(String currentTitle, ActiveButton active,
    Map weatherDataMap, bool isDay, double offset) {
  int timeOffset = offset.toInt();
  int startIndex = 165 + timeOffset;
  int endIndex = 165 + 23 + timeOffset;
  double tempMin = 30;
  double tempMax = 30;
  double temp;
  if (currentTitle == 'Tomorrow') {
    startIndex = 165 + 24 + timeOffset;
    endIndex = startIndex + 23;
  } else if (currentTitle == 'Yesterday') {
    startIndex = 165 - 24 + timeOffset;
    endIndex = startIndex + 23;
  } else if (currentTitle == 'Next 7 Days') {
    startIndex = 8;
    endIndex = 14;
  } else if (currentTitle == 'Past 7 Days') {
    startIndex = 0;
    endIndex = 6;
  } else {
    startIndex = 165 + timeOffset;
    endIndex = startIndex + 23;
  }
  List<Container> displayWeatherInfo = [];

  String formattingDate(int value) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(value * 1000);
    if (endIndex < 15) {
      return DateFormat('d MMMM, EEEE').format(dateTime);
    }
    String formattedDate = DateFormat.jm().format(dateTime);
    if (formattedDate == '12:30 AM') {
      formattedDate = '1:00 AM';
    } else if (formattedDate == '1:30 AM') {
      formattedDate = '2:00 AM';
    } else if (formattedDate == '2:30 AM') {
      formattedDate = '3:00 AM';
    } else if (formattedDate == '3:30 AM') {
      formattedDate = '4:00 AM';
    } else if (formattedDate == '4:30 AM') {
      formattedDate = '5:00 AM';
    } else if (formattedDate == '5:30 AM') {
      formattedDate = '6:00 AM';
    } else if (formattedDate == '6:30 AM') {
      formattedDate = '7:00 AM';
    } else if (formattedDate == '7:30 AM') {
      formattedDate = '8:00 AM';
    } else if (formattedDate == '8:30 AM') {
      formattedDate = '9:00 AM';
    } else if (formattedDate == '9:30 AM') {
      formattedDate = '10:00 AM';
    } else if (formattedDate == '10:30 AM') {
      formattedDate = '11:00 AM';
    } else if (formattedDate == '11:30 AM') {
      formattedDate = '12:00 PM';
    } else if (formattedDate == '12:30 PM') {
      formattedDate = '1:00 PM';
    } else if (formattedDate == '1:30 PM') {
      formattedDate = '2:00 PM';
    } else if (formattedDate == '2:30 PM') {
      formattedDate = '3:00 PM';
    } else if (formattedDate == '3:30 PM') {
      formattedDate = '4:00 PM';
    } else if (formattedDate == '4:30 PM') {
      formattedDate = '5:00 PM';
    } else if (formattedDate == '5:30 PM') {
      formattedDate = '6:00 PM';
    } else if (formattedDate == '6:30 PM') {
      formattedDate = '7:00 PM';
    } else if (formattedDate == '7:30 PM') {
      formattedDate = '8:00 PM';
    } else if (formattedDate == '8:30 PM') {
      formattedDate = '9:00 PM';
    } else if (formattedDate == '9:30 PM') {
      formattedDate = '10:00 PM';
    } else if (formattedDate == '10:30 PM') {
      formattedDate = '11:00 PM';
    } else if (formattedDate == '11:30 PM') {
      formattedDate = '12:00 AM';
    }
    // String formattedDate = DateFormat.jm().format(dateTime);
    if (formattedDate == '12:00 AM') {
      return 'Midnight';
    }
    if (formattedDate == '12:00 PM') {
      return 'Noon';
    }
    return formattedDate;
  }

  for (int i = startIndex; i <= endIndex; i++) {
    temp = weatherDataMap['hourly']['temperature_2m'][i];
    if (endIndex < 15) {
      tempMin = weatherDataMap['daily']['temperature_2m_min'][i];
      tempMax = weatherDataMap['daily']['temperature_2m_max'][i];
    }
    displayWeatherInfo.add(Container(
      constraints: BoxConstraints(minWidth: 300, maxWidth: 700),

      padding: EdgeInsets.symmetric(vertical: 0),
      margin: EdgeInsets.symmetric(horizontal: 0),
      // (i != 23) ? EdgeInsets.only(right: 12) : EdgeInsets.only(right: 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                (endIndex < 15)
                    ? formattingDate(weatherDataMap['daily']['time'][i])
                    : formattingDate(weatherDataMap['hourly']['time'][i]),
                style: kSmallDarkTextStyle.copyWith(color: Colors.white),
              ),
              Text(
                  (endIndex < 15)
                      ? '${tempMin.round()}º/${tempMax.round()}º'
                      : '${temp.toStringAsFixed(1)}º',
                  style: kSmallDarkTextStyle.copyWith(color: Colors.white)),
            ],
          ),
          Visibility(
            visible: (i == endIndex) ? false : true,
            child: Divider(
              height: 030,
              thickness: 0.2,
              color: Colors.white,
              indent: 8,
              endIndent: 8,
            ),
          )
        ],
      ),
    ));
  }
  return displayWeatherInfo;
}
