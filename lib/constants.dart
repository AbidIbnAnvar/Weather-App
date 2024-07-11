import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const climateData = {
  0: 'Clear',
  1: 'Mostly Clear',
  2: 'Partly Cloudy',
  3: 'Cloudy',
  45: 'Fog',
  48: 'Freezing Fog',
  51: 'Light Drizzle',
  53: 'Drizzle',
  55: 'Heavy Drizzle',
  56: 'Light Freezing Drizzle',
  57: 'Freezing Drizzle',
  61: 'Light Rain',
  63: 'Rain',
  65: 'Heavy Rain',
  66: 'Light Freezing Rain',
  67: 'Freezing Rain',
  71: 'Light Snow',
  73: 'Snow',
  75: 'Heavy Snow',
  77: 'Snow Grains',
  80: 'Light Rain Shower',
  81: 'Rain Shower',
  82: 'Heavy Rain Shower',
  85: 'Snow Shower',
  86: 'Heavy Snow Shower',
  95: 'Thunderstorm',
  96: 'Hailstorm',
  99: 'Heavy Hailstorm'
};

const climateImage = {
  'Clear': 'Clear',
  'Mostly Clear': 'Clear',
  'Partly Cloudy': 'Cloudy',
  'Cloudy': 'Cloudy',
  'Fog': 'Cloudy',
  'Freezing Fog': 'Cloudy',
  'Light Drizzle': 'Rainy',
  'Drizzle': 'Rainy',
  'Heavy Drizzle': 'Rainy',
  'Light Freezing Drizzle': 'Rainy',
  'Freezing Drizzle': 'Rainy',
  'Light Rain': 'Rainy',
  'Rain': 'Rainy',
  'Heavy Rain': 'Rainy',
  'Light Freezing Rain': 'Rainy',
  'Freezing Rain': 'Rainy',
  'Light Snow': 'Snow',
  'Snow': 'Snow',
  'Heavy Snow': 'Snow',
  'Snow Grains': 'Snow',
  'Light Rain Shower': 'Rainy',
  'Rain Shower': 'Rainy',
  'Heavy Rain Shower': 'Rainy',
  'Snow Shower': 'Rainy',
  'Heavy Snow Shower': 'Rainy',
  'Thunderstorm': 'Thunderstorm',
  'Hailstorm': 'Hailstorm',
  'Heavy Hailstorm': 'Hailstorm'
};

const defaultColor = Color(0xFF202329);
const defaultForegroundColor = Color(0xFFAFB0B2);

const dayTimeColor1 = Color(0xB90080FF);
const dayTimeColor2 = Color(0xB941A1F7);

const nightTimeColor1 = Color(0xFF00060c);
const nightTimeColor2 = Color(0x39000080);

const nightWidgetColor = Color(0x320777E2);
const dayWidgetColor = Color(0x59000035);

const TextStyle kSmallDarkTextStyle = TextStyle(
  fontSize: 16,
  color: Color(0xFFcecece),
  letterSpacing: 0.75,
  fontFamily: 'RB',
);

const TextStyle kSmallLightTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.white,
  letterSpacing: 0.75,
  fontFamily: 'RB',
);
