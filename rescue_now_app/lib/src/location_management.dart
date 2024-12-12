import 'dart:ffi';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
//ca sa poti sa faci json si inapoi
// import 'dart:convert';

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> determinePosition() async {
  late bool serviceEnabled;
  late LocationPermission permission;

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

Future<http.Response> sendLocationToServer(double latitude, double longitude) async {
  final queryParams = {
    'lat' : latitude.toString(),
    'long' : longitude.toString()
  };
  final uri = Uri.http('0.0.0.0:8000', '/location', queryParams);

  return http.put(uri);
}

void getAndSendLocation() async {
  Position position = await determinePosition();
  print(position);
  final response = await sendLocationToServer(position.latitude, position.longitude);
  print('response de la server');
  print(response);
}
