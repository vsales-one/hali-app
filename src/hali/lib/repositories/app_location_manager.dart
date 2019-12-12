import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hali/di/appModule.dart';

class AppLocationManager {
  static Future<Position> initCurrentLocation() async {
    Position position;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final Geolocator geolocator = Geolocator()
        ..forceAndroidLocationManager = true;

      position = await geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium)
          .timeout(Duration(seconds: 10), onTimeout: () {
        return Position(latitude: 10.762622, longitude: 106.660172);
      });
    } on PlatformException catch (e) {
      position = null;
      logger.e(
          'AppLocationManager_initCurrentLocation got error ->' + e.toString());
    }

    return position;
  }
}
