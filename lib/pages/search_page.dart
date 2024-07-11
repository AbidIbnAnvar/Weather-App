import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/pages/loading_page2.dart';
import 'package:weather_app/variables.dart';

class City {
  final String name;
  final String country;
  final double latitude;
  final double longitude;
  final double timezoneOffset;

  City(
      {required this.name,
      required this.country,
      required this.latitude,
      required this.longitude,
      required this.timezoneOffset});
}

class SearchPage extends StatefulWidget {
  final bool isDay;
  const SearchPage({super.key, required this.isDay});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchText = '';
  TextEditingController textEditingController = TextEditingController();
  List<City> cities = [
    City(
        name: 'New York',
        country: 'USA',
        latitude: 40.7128,
        longitude: -74.0060,
        timezoneOffset: -4.0),
    City(
        name: 'London',
        country: 'UK',
        latitude: 51.5074,
        longitude: -0.1278,
        timezoneOffset: 1.0),
    City(
        name: 'Paris',
        country: 'France',
        latitude: 48.8566,
        longitude: 2.3522,
        timezoneOffset: 2.0),
    City(
        name: 'Tokyo',
        country: 'Japan',
        latitude: 35.6895,
        longitude: 139.6917,
        timezoneOffset: 9.0),
    City(
        name: 'Sydney',
        country: 'Australia',
        latitude: -33.8688,
        longitude: 151.2093,
        timezoneOffset: 10.0),
    City(
        name: 'Berlin',
        country: 'Germany',
        latitude: 52.5200,
        longitude: 13.4050,
        timezoneOffset: 2.0),
    City(
        name: 'Rome',
        country: 'Italy',
        latitude: 41.9028,
        longitude: 12.4964,
        timezoneOffset: 2.0),
    City(
        name: 'Moscow',
        country: 'Russia',
        latitude: 55.7558,
        longitude: 37.6176,
        timezoneOffset: 3.0),
    City(
        name: 'Beijing',
        country: 'China',
        latitude: 39.9042,
        longitude: 116.4074,
        timezoneOffset: 8.0),
    City(
        name: 'Cairo',
        country: 'Egypt',
        latitude: 30.0330,
        longitude: 31.2336,
        timezoneOffset: 3.0),
    City(
        name: 'Rio de Janeiro',
        country: 'Brazil',
        latitude: -22.9068,
        longitude: -43.1729,
        timezoneOffset: -3.0),
    City(
        name: 'Mexico City',
        country: 'Mexico',
        latitude: 19.4326,
        longitude: -99.1332,
        timezoneOffset: -6.0),
    City(
        name: 'Cape Town',
        country: 'South Africa',
        latitude: -33.9249,
        longitude: 18.4241,
        timezoneOffset: 2.0),
    City(
        name: 'Dubai',
        country: 'UAE',
        latitude: 25.2769,
        longitude: 55.2963,
        timezoneOffset: 4.0),
    City(
        name: 'Mumbai',
        country: 'India',
        latitude: 19.0760,
        longitude: 72.8777,
        timezoneOffset: 5.0),
    City(
        name: 'Toronto',
        country: 'Canada',
        latitude: 43.6511,
        longitude: -79.3832,
        timezoneOffset: -4.0),
    City(
        name: 'Buenos Aires',
        country: 'Argentina',
        latitude: -34.6037,
        longitude: -58.3816,
        timezoneOffset: -3.0),
    City(
        name: 'Seoul',
        country: 'South Korea',
        latitude: 37.5665,
        longitude: 126.9780,
        timezoneOffset: 9.0),
    City(
        name: 'Madrid',
        country: 'Spain',
        latitude: 40.4168,
        longitude: -3.7038,
        timezoneOffset: 2.0),
    City(
        name: 'Lagos',
        country: 'Nigeria',
        latitude: 6.5244,
        longitude: 3.3792,
        timezoneOffset: 1.0),
    City(
        name: 'Los Angeles',
        country: 'USA',
        latitude: 34.0522,
        longitude: -118.2437,
        timezoneOffset: -7.0),
    City(
        name: 'Amsterdam',
        country: 'Netherlands',
        latitude: 52.3676,
        longitude: 4.9041,
        timezoneOffset: 2.0),
    City(
        name: 'Bangkok',
        country: 'Thailand',
        latitude: 13.7563,
        longitude: 100.5018,
        timezoneOffset: 7.0),
    City(
        name: 'Athens',
        country: 'Greece',
        latitude: 37.9838,
        longitude: 23.7275,
        timezoneOffset: 3.0),
    City(
        name: 'Hanoi',
        country: 'Vietnam',
        latitude: 21.0278,
        longitude: 105.8342,
        timezoneOffset: 7.0),
    City(
        name: 'Singapore',
        country: 'Singapore',
        latitude: 1.3521,
        longitude: 103.8198,
        timezoneOffset: 8.0),
    City(
        name: 'Dublin',
        country: 'Ireland',
        latitude: 53.3498,
        longitude: -6.2603,
        timezoneOffset: 1.0),
    City(
        name: 'Prague',
        country: 'Czech Republic',
        latitude: 50.0880,
        longitude: 14.4208,
        timezoneOffset: 1.0),
    City(
        name: 'Stockholm',
        country: 'Sweden',
        latitude: 59.3293,
        longitude: 18.0686,
        timezoneOffset: 2.0),
    City(
        name: 'Budapest',
        country: 'Hungary',
        latitude: 47.4979,
        longitude: 19.0402,
        timezoneOffset: 2.0),
    City(
        name: 'Lisbon',
        country: 'Portugal',
        latitude: 38.7163,
        longitude: -9.1393,
        timezoneOffset: 1.0),
    City(
        name: 'Vienna',
        country: 'Austria',
        latitude: 48.2082,
        longitude: 16.3738,
        timezoneOffset: 2.0),
    City(
        name: 'Warsaw',
        country: 'Poland',
        latitude: 52.2298,
        longitude: 21.0118,
        timezoneOffset: 2.0),
    City(
        name: 'Oslo',
        country: 'Norway',
        latitude: 59.9139,
        longitude: 10.7522,
        timezoneOffset: 2.0),
    City(
        name: 'Copenhagen',
        country: 'Denmark',
        latitude: 55.6761,
        longitude: 12.5683,
        timezoneOffset: 2.0),
    City(
        name: 'Helsinki',
        country: 'Finland',
        latitude: 60.1699,
        longitude: 24.9384,
        timezoneOffset: 3.0),
    City(
        name: 'Wellington',
        country: 'New Zealand',
        latitude: -41.2865,
        longitude: 174.7762,
        timezoneOffset: 12.0),
    City(
        name: 'Jakarta',
        country: 'Indonesia',
        latitude: -6.2088,
        longitude: 106.8456,
        timezoneOffset: 7.0),
    City(
        name: 'Kuala Lumpur',
        country: 'Malaysia',
        latitude: 3.1390,
        longitude: 101.6869,
        timezoneOffset: 8.0),
    City(
        name: 'Manila',
        country: 'Philippines',
        latitude: 14.5995,
        longitude: 120.9842,
        timezoneOffset: 8.0),
    City(
        name: 'Seville',
        country: 'Spain',
        latitude: 37.3891,
        longitude: -5.9845,
        timezoneOffset: 2.0),
    City(
        name: 'Florence',
        country: 'Italy',
        latitude: 43.7696,
        longitude: 11.2558,
        timezoneOffset: 2.0),
    City(
        name: 'Edinburgh',
        country: 'UK',
        latitude: 55.9533,
        longitude: -3.1883,
        timezoneOffset: 1.0),
    City(
        name: 'Barcelona',
        country: 'Spain',
        latitude: 41.3851,
        longitude: 2.1734,
        timezoneOffset: 2.0),
    City(
        name: 'Edmonton',
        country: 'Canada',
        latitude: 53.5461,
        longitude: -113.4938,
        timezoneOffset: -6.0),
    City(
        name: 'Vancouver',
        country: 'Canada',
        latitude: 49.2827,
        longitude: -123.1207,
        timezoneOffset: -7.0),
    City(
        name: 'Montreal',
        country: 'Canada',
        latitude: 45.5017,
        longitude: -73.5673,
        timezoneOffset: -4.0),
    City(
        name: 'San Francisco',
        country: 'USA',
        latitude: 37.7749,
        longitude: -122.4194,
        timezoneOffset: -7.0),
    City(
        name: 'Chicago',
        country: 'USA',
        latitude: 41.8781,
        longitude: -87.6298,
        timezoneOffset: -5.0),
    City(
        name: 'Seattle',
        country: 'USA',
        latitude: 47.6062,
        longitude: -122.3321,
        timezoneOffset: -7.0),
  ];

  Column searchEmpty() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flex(
          direction: Axis.vertical,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoadingPage2(
                              city: _searchText,
                            )));
              },
              style: ButtonStyle(
                padding: WidgetStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(vertical: 16, horizontal: 24)),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10.0), // Adjust border radius as needed
                    side: BorderSide(
                        color: Colors.blue), // Optional: add a border side
                  ),
                ),
                foregroundColor:
                    WidgetStateProperty.all<Color>(Colors.white), // Text color
                backgroundColor: WidgetStateProperty.all<Color>(widget.isDay
                    ? dayWidgetColor
                    : nightWidgetColor), // Background color
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      'Search for $_searchText\'s weather',
                      style: TextStyle(fontFamily: 'RB Medium', fontSize: 16),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'The weather data might be inaccurate',
          style: (widget.isDay)
              ? kSmallLightTextStyle.copyWith(fontSize: 10)
              : kSmallDarkTextStyle.copyWith(fontSize: 10),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    print(cities.length);
  }

  @override
  Widget build(BuildContext context) {
    List<City> filteredCities = cities.where((city) {
      // Filter city based on search text
      return city.name.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: (widget.isDay) ? dayTimeColor1 : nightTimeColor1,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: (widget.isDay)
                    ? [dayTimeColor1, dayTimeColor2]
                    : [nightTimeColor1, nightTimeColor2],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RawMaterialButton(
                    constraints:
                        const BoxConstraints.tightFor(width: 40, height: 40),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    fillColor:
                        (widget.isDay) ? dayWidgetColor : nightWidgetColor,
                    child: Icon(
                      Icons.keyboard_arrow_left_rounded,
                      // Icons.grid_view_rounded,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: TextField(
                        cursorColor: Colors.grey,
                        controller: textEditingController,
                        decoration: InputDecoration(
                            hintText: 'Enter a city',
                            hintStyle: kSmallDarkTextStyle.copyWith(
                                color: Colors.white),
                            fillColor: (widget.isDay)
                                ? dayWidgetColor
                                : nightWidgetColor, // Set your desired fill color
                            filled: true, // Ensure the background is filled
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(
                                  10.0), // Example rounded corners
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            constraints: BoxConstraints.tightFor(height: 40) //
                            ),
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: (value) {
                          setState(() {
                            _searchText = value;
                          });
                        },
                      ),
                    ),
                  ),
                  RawMaterialButton(
                    constraints:
                        const BoxConstraints.tightFor(width: 40, height: 40),
                    onPressed: () {
                      setState(() {
                        _searchText = '';
                        textEditingController.clear();
                      });
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    fillColor:
                        (widget.isDay) ? dayWidgetColor : nightWidgetColor,
                    elevation: 0,
                    child: Icon(
                      Icons.close_rounded,
                      // Icons.grid_view_rounded,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: (filteredCities.isNotEmpty)
                    ? ListView.builder(
                        itemCount: filteredCities.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  offset = filteredCities[index].timezoneOffset;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoadingPage2(
                                              offset: filteredCities[index]
                                                  .timezoneOffset,
                                              country:
                                                  filteredCities[index].country,
                                              city: filteredCities[index].name,
                                              latitude: filteredCities[index]
                                                  .latitude,
                                              longitude: filteredCities[index]
                                                  .longitude)));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0x00000000),
                                  ),
                                  padding: EdgeInsets.only(
                                      top: 12, bottom: 12, left: 12, right: 12),
                                  child: Row(
                                    textBaseline: TextBaseline.alphabetic,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    children: [
                                      Text(
                                        filteredCities[index].name,
                                        style: TextStyle(
                                            fontFamily: 'RB Medium',
                                            fontSize: 20),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        filteredCities[index].country,
                                        style: (widget.isDay)
                                            ? kSmallLightTextStyle
                                            : kSmallDarkTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: (index == filteredCities.length - 1)
                                    ? false
                                    : true,
                                child: Divider(
                                  thickness: 0.2,
                                  color: Colors.white,
                                  indent: 12,
                                  endIndent: 12,
                                ),
                              )
                            ],
                          );

                          // return ListTile(
                          //   title: Text(filteredCities[index].name),
                          //   subtitle: Text(filteredCities[index].country),
                          //   onTap: () {
                          //     print(filteredCities[index].name);
                          //   },
                          // );
                        },
                      )
                    : searchEmpty(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
