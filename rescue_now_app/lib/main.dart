import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rescue_now_app/crash_detection.dart';
import 'firebase_options.dart';
import 'profile_screen.dart';
// ignore_for_file: avoid_print

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emergency SOS',
      theme: ThemeData(
        primarySwatch: Colors.red,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Add the crash detection button on the left side
        leading: IconButton(
          icon: const Icon(Icons.warning),
          tooltip: 'Open Crash Detection',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CrashDetectionScreen(),
              ),
            );
          },
        ),
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new),
            tooltip: 'Open Profile',
            // Open ProfileScreen when the button is pressed
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                // Open the SOS menu when tapped
                showEmergencyMenu(context);
              },
              onLongPress: () {
                // Open a new tab (screen) when the button is long-pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewTabScreen()),
                );
              },
              child: ElevatedButton(
                onPressed: null,
                child: const Text('Open Tab'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showEmergencyMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.video_call, color: Colors.red),
                title: const Text('Apel video la urgențe'),
                onTap: () {
                  initiateVideoCall();
                  sendSOSAlert();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.call, color: Colors.red),
                title: const Text('Apel vocal + Alertă SOS contacte'),
                onTap: () {
                  initiateVoiceCall();
                  sendSOSAlert();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.message, color: Colors.red),
                title: const Text('Mesaj simplu + Alertă SOS contacte'),
                onTap: () {
                  sendSimpleMessage();
                  sendSOSAlert();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void initiateVideoCall() {
    // Placeholder for video call implementation
    print("Inițiere apel video către urgențe...");
  }

  void initiateVoiceCall() {
    // Placeholder for voice call implementation
    print("Inițiere apel vocal către urgențe...");
  }

  void sendSimpleMessage() {
    // Placeholder for sending a simple message to emergency contacts
    print("Trimitere mesaj text către contacte de urgență...");
  }

  void sendSOSAlert() {
    // Placeholder for sending an SOS alert, e.g., with current location
    print("Trimitere alertă SOS către contacte de urgență...");
  }
}

// New screen that opens on long press
class NewTabScreen extends StatelessWidget {
  const NewTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Tab Screen'),
      ),
      body: const Center(
        child: Text('This is a new tab opened by long-pressing the button'),
      ),
    );
  }
}