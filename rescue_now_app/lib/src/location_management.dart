import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:rescue_now_app/src/patient.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

Future<String> postSendLocation(Uri uri) async {
  print('sending post request');
  final response =
      await http.post(uri, headers: {'Content-Type': 'application/json'});

  // save the id that the server gave us
  // parse from json response
  print(response.body );
  return json.decode(response.body)['id'];
}

Future<String> putSendLocation(Uri uri) async {
  print('sending put request');
  final response =
      await http.put(uri, headers: {'Content-Type': 'application/json'});
  print('put response');
  print(response.body);
  if (response.statusCode == 404) {
    return await postSendLocation(uri);
  }
  return "Patient found";
}

Future<String> sendLocationToServer(
    double latitude, double longitude, String patientId) async {
  /// da return la id-u de la pacientu creat daca nu a mai fost creat inainte, si "Patient Found" daca a gasit
  final queryParams = {
    'lat': latitude.toString(),
    'long': longitude.toString(),
    'patientID': patientId
  };
  final uri = Uri.http('0.0.0.0:8000', '/location', queryParams);

  //POST nu s-a setat inca idul adica inca n-am dat call deloc
  if (patientId == 'gol lol') {
    return await postSendLocation(uri);
  }
  //PUT a fost setat idul, deci vrem sa updatam datele
  else {
    return await putSendLocation(uri);
  }
}

Future<Position> getAndSendLocation() async {
  // try pinging the server if it's even online
  Position position = await determinePosition();
  print(position);
  SharedPreferencesAsync prefs = SharedPreferencesAsync();
  String? patientJson = await prefs.getString('patientData');
  Patient patient;
  // if it already exists
  if (patientJson != null) {
    patient = Patient.fromJson(json.decode(patientJson));
  } else {
    // init with default values
    patient = Patient();
  }

  patient.longitude = position.longitude;
  patient.latitude = position.latitude;

  var response;
  try {
    response = await sendLocationToServer(
        patient.latitude, patient.longitude, patient.id);
  } catch (e) {
    print(e);
    return position;
  }

  //save patient back to prefs
  if (response != "Patient found") {
    // this means it's an id
    patient.id = response;
  }
  print('response de la server');
  print(response);

  await prefs.setString('patientData', json.encode(patient.toJson()));
  return position;
}
