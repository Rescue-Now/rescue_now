import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';
// ignore_for_file: avoid_print

class CrashDetectionScreen extends StatefulWidget {
  const CrashDetectionScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CrashDetectionScreenState createState() => _CrashDetectionScreenState();
}

class _CrashDetectionScreenState extends State<CrashDetectionScreen> {
  static const double crashThreshold = 45;

  double _accelerationMagnitude = 0.0;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  bool _crashDetected = false;
  Timer? _confirmationTimer;

  @override
  void initState() {
    super.initState();
    _startAccelerometerListener();
  }

  @override
  void dispose() {
    // Cancel the accelerometer subscription
    _accelerometerSubscription?.cancel();
    _confirmationTimer?.cancel();
    super.dispose();
  }

  static double gravitationalConstant = 9.8;

  double _calculateMagnitude(AccelerometerEvent event) {
    return sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
  }

  void _startAccelerometerListener() {
    _accelerometerSubscription = accelerometerEventStream(
      samplingPeriod: SensorInterval.normalInterval,
    ).listen((AccelerometerEvent event) {
      double accelerationMagnitude = _calculateMagnitude(event);
      double adjustedMagnitude = (accelerationMagnitude - gravitationalConstant).abs();

      // Check if the widget is still mounted before calling setState
      if (mounted) {
        setState(() {
          _accelerationMagnitude = adjustedMagnitude;
        });
      }

      if (adjustedMagnitude > crashThreshold && !_crashDetected) {
        _crashDetected = true;
        _showCrashDetectedDialog();
        print(adjustedMagnitude);
        _initiateEmergencyResponse();
      }
    });
  }

  void _showCrashDetectedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Possible Crash Detected'),
          content: Text(
              'It seems like a crash may have occurred. Press "Cancel" if this is not correct.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                setState(() {
                  _crashDetected = false;
                });
                Navigator.of(context).pop();
                _confirmationTimer?.cancel();
              },
            ),
          ],
        );
      },
    );

    // Start a timer to initiate emergency response after countdown if no action
    _confirmationTimer = Timer(Duration(seconds: 5), () {
      if (_crashDetected && mounted) {
        _initiateEmergencyResponse();
        Navigator.of(context).pop();
      }
    });
  }

  void _initiateEmergencyResponse() {
    if (mounted) {
      print('Emergency response initiated.');
      setState(() {
        _crashDetected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crash Detection Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Current Acceleration:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              '${_accelerationMagnitude.toStringAsFixed(2)} G',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              _crashDetected
                  ? 'Crash Detected! Initiating Emergency Response...'
                  : 'Monitoring...',
              style: TextStyle(
                fontSize: 18,
                color: _crashDetected ? Colors.red : Colors.green,
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _simulateCrash,
              child: Text('Simulate Crash'),
            ),
          ],
        ),
      ),
    );
  }

  void _simulateCrash() {
    _accelerometerSubscription?.cancel();

    double simulatedX = 95;
    double simulatedY = 0.0;
    double simulatedZ = 0.0;
    double simulatedMagnitude = sqrt(simulatedX * simulatedX + simulatedY * simulatedY + simulatedZ * simulatedZ);
    double adjustedMagnitude = (simulatedMagnitude - gravitationalConstant).abs();

    if (mounted) {
      setState(() {
        _accelerationMagnitude = adjustedMagnitude;
      });
    }

    if (adjustedMagnitude > crashThreshold && !_crashDetected) {
      _crashDetected = true;
      _showCrashDetectedDialog();
    }

    // Restart the accelerometer listener after a few seconds
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        _startAccelerometerListener();
      }
    });
  }
}