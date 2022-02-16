import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

bool? _serviceEnabled;
LocationPermission? _permission;

Future<Position?> getPosition() async {
  try {
    _serviceEnabled ??= await Geolocator.isLocationServiceEnabled();

    if (!_serviceEnabled!) {
      return Future.error('Location services are disabled');
    }

    _permission ??= await Geolocator.checkPermission();
    if (_permission == LocationPermission.denied) {
      _permission = await Geolocator.requestPermission();
      if (_permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (_permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions');
    }

    try {
      return await Geolocator.getLastKnownPosition();
    } on PlatformException {
      return await Geolocator.getCurrentPosition();
    }
  } catch (_) {
    return Future.error('Error getting location');
  }
}
