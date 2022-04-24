// ignore_for_file: avoid_print

import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as l;

class LocationHelper {
  static Future getUserLocation() async {
    l.LocationData? myLocation;
    String error = "ERROR getUserLocation: ";
    l.Location location = l.Location();
    List<Placemark> placemarks = [];
    try {
      myLocation = await location.getLocation();
      placemarks = await placemarkFromCoordinates(
          myLocation.latitude ?? 0, myLocation.longitude ?? 0);
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error += 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error += 'permission denied- please enable it from app settings';
        print(error);
      }
      myLocation = null;
    }

    // this is all you need
    Placemark placeMark = placemarks[0];
    return placeMark;
  }
}
