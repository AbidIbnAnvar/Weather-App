import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum ActiveButton { today, tomorrow, yesterday, next7days, past7days }

ActiveButton active = ActiveButton.today;

enum ActiveUnit { celsius, fahrenheit }

ActiveUnit activeUnit = ActiveUnit.celsius;

late double offset;

String temperatureUnit = 'C';
double doubleValue = 15.0;
Map<ActiveButton, String> buttonTitle = {
  ActiveButton.today: 'Today',
  ActiveButton.tomorrow: 'Tomorrow',
  ActiveButton.past7days: 'Past 7 Days',
  ActiveButton.next7days: 'Next 7 Days',
  ActiveButton.yesterday: 'Yesterday',
};

//loading_page

String getApiKey() {
  return dotenv.env['OWM_API_KEY'] ?? '';
}
