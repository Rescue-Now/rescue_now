import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rescue_now_app/crash_detection.dart'; // Update this to the correct path if necessary

void main() {
  testWidgets('Crash Detection App Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(CrashDetectionApp());

    // Verify that the app shows the initial UI elements.
    expect(find.text('Current Acceleration:'), findsOneWidget);
    expect(find.text('Monitoring...'), findsOneWidget);
  });
}