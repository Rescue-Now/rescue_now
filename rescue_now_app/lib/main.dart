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
       //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
  final Color backgroundColor = Color(0xFFFFE5E5); // Replace with the exact background color from Penpot
  final Color buttonColor = Color(0xFFD9A4A4); // Replace with the SOS button color
  final Color textColor = Color(0xFF5A2F2F); // Replace with the icon/text color

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Row
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildIconWithLabel(
                    icon: Icons.contacts,
                    label: 'Contacts',
                    onTap: () {
                      // Navigate to Contacts screen or handle the action
                      print('Contacts tapped');
                    },
                  ),
                  _buildIconWithLabel(
                    icon: Icons.car_crash,
                    label: 'Crash test',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CrashDetectionScreen(),
                        ),
                      );
                    },
                  ),
                  _buildIconWithLabel(
                    icon: Icons.person,
                    label: 'Profile',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Center SOS Button
            GestureDetector(
              onTap: () {
                showEmergencyMenu(context);
              },
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.car_repair, color: Colors.white, size: 40),
                      Text(
                        'SOS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Help Options Button
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  // Handle Help Options action
                  print('Help options pressed');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 10,
                  ),
                ),
                child: Text(
                  'Help options',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build an icon with label
  Widget _buildIconWithLabel({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: textColor, size: 40),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: textColor, fontSize: 14)),
        ],
      ),
    );
  }

  // Show emergency menu (already implemented)
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

  void initiateVideoCall() => print("Inițiere apel video către urgențe...");
  void initiateVoiceCall() => print("Inițiere apel vocal către urgențe...");
  void sendSimpleMessage() =>
      print("Trimitere mesaj text către contacte de urgență...");
  void sendSOSAlert() =>
      print("Trimitere alertă SOS către contacte de urgență...");
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