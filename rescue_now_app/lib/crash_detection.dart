import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';

class CrashDetectionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CrashDetectionScreen(),
    );
  }
}

class CrashDetectionScreen extends StatefulWidget {
  @override
  _CrashDetectionScreenState createState() => _CrashDetectionScreenState();
}

class _CrashDetectionScreenState extends State<CrashDetectionScreen> {
  // Threshold for crash detection (in G-forces).
  static const double crashThreshold = 3.0;

  // Variables for accelerometer data
  double _accelerationMagnitude = 0.0;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  // Crash detection status
  bool _crashDetected = false;
  Timer? _confirmationTimer;

  @override
  void initState() {
    super.initState();
    _startAccelerometerListener();
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _confirmationTimer?.cancel();
    super.dispose();
  }

  void _startAccelerometerListener() {
    _accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
          // Calculate the magnitude of the acceleration vector
          double accelerationMagnitude = _calculateMagnitude(event);

          setState(() {
            _accelerationMagnitude = accelerationMagnitude;
          });

          // Check if the acceleration exceeds the crash threshold
          if (accelerationMagnitude > crashThreshold && !_crashDetected) {
            _crashDetected = true;
            _showCrashDetectedDialog();
          }
        });
  }

  double _calculateMagnitude(AccelerometerEvent event) {
    return sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
  }

  // Simulate crash by setting mock acceleration data
  void _simulateCrash() {
    // Simulated acceleration values that exceed the crash threshold
    double simulatedX = 3.5;
    double simulatedY = 0.0;
    double simulatedZ = 0.0;
    double simulatedMagnitude = sqrt(simulatedX * simulatedX + simulatedY * simulatedY + simulatedZ * simulatedZ);

    setState(() {
      _accelerationMagnitude = simulatedMagnitude;
    });

    if (simulatedMagnitude > crashThreshold && !_crashDetected) {
      _crashDetected = true;
      _showCrashDetectedDialog();
    }
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
      if (_crashDetected) {
        _initiateEmergencyResponse();
        Navigator.of(context).pop();
      }
    });
  }

  void _initiateEmergencyResponse() {
    // Here you can add functionality to initiate an emergency call or send location
    // For demonstration, we'll just print a message
    print('Emergency response initiated.');
    setState(() {
      _crashDetected = false;
    });
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
              _accelerationMagnitude.toStringAsFixed(2) + ' G',
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
}