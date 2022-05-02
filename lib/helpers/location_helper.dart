// ignore_for_file: avoid_print

import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as l;
import 'package:geolocator/geolocator.dart';

class LocationHelper {
  static Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
  static Future getUserLocation() async {
    Position? myLocation;
    // l.LocationData? myLocation;
    String error = "ERROR getUserLocation: ";
    l.Location location = l.Location();
    List<Placemark> placemarks = [];
    print("LocationHelper");
    try {
      // myLocation = await location.getLocation();
       myLocation = await _determinePosition();      
      print(1);
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



/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.

