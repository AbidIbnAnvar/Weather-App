import 'package:geolocator/geolocator.dart';

class Location {
  late double latitude;
  late double longitude;
  late Position position;

  Future<void> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low);
        latitude = position.latitude;
        longitude = position.longitude;
        print(latitude);
        print(longitude);
      } else {
        print('Access to location is denied.');
      }
    } catch (e) {
      print('Error in Location');
    }
  }
}
