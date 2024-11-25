import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rescue_now_app/src/crash_detection.dart';
import 'src/firebase_options.dart';
import 'src/profile_screen.dart';
import 'theme/app_theme.dart';
// ignore_for_file: avoid_print
import 'package:flutter_svg/flutter_svg.dart'; 

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
        primarySwatch: Colors.brown,
        //colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFEEA798)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}
class ImageIcon extends StatelessWidget {
  const ImageIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Image Icon tapped');
      },
      child: SizedBox(
        height: 40,  // Ensure proper size for interaction
        width: 40,   // Ensure proper size for interaction
        child: SvgPicture.asset(
          'assets/info svg-2.svg', // Path to your image asset
          fit: BoxFit.contain,  // Ensure proper fitting of the image within the SizedBox
        ),
      ),
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
      backgroundColor: AppTheme.colors.background, // !exemplu de color
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
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: Color(0xFF885053),
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
                      SvgPicture.asset(
                        'assets/sos_button.svg'
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
      // Show emergency menu
      showEmergencyMenu(context);
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: AppTheme.colors.menuButtons,
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
      style: TextStyle(color: AppTheme.colors.text, fontSize: 16), // !exemplu de color
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
          Icon(icon, color: AppTheme.colors.menuButtons, size: 40),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: AppTheme.colors.menuButtons, fontSize: 14)),
        ],
      ),
    );
  }
void showEmergencyMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(50.0),  // More curved top-left corner
        topRight: Radius.circular(50.0), // More curved top-right corner
      ),
    ),
    builder: (BuildContext context) {
      return Container(

        decoration: const BoxDecoration(
          color: Color(0xFF4C3527), // Background color of the popup
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.0),  // Must match the borderRadius in shape
            topRight: Radius.circular(50.0), // Must match the borderRadius in shape
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Draggable Indicator
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white, // Keep the draggable indicator white
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            // Emergency Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildModalButton(
                    label: 'Send Emergency Text',
                    onTap: () {
                      print('Send Text Emergency tapped');
                      Navigator.pop(context);
                    },
                  ),
                  _buildModalButton(
                    label: 'Voice Emergency Call',
                    onTap: () {
                      print('Voice Emergency Call tapped');
                      Navigator.pop(context);
                    },
                  ),
                  _buildModalButton(
                    label: 'Video Emergency Call',
                    onTap: () {
                      print('Video Emergency Call tapped');
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
           const SizedBox(height: 20),
// Info Text
const Padding(
  padding: EdgeInsets.symmetric(horizontal: 20.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center, // Center content horizontally
    children: [
      ImageIcon(),
      SizedBox(width: 8), // Space between the icon and text
      Expanded(
        child: Text(
          'Initiating any kind of help request will also alert emergency contacts.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white, // Text color
            fontSize: 14,        // Font size
          ),
        ),
      ),
    ],
  ),
),

const SizedBox(height: 20),

          ],
        ),
      );
    },
  );
}

// Helper to build the individual buttons in the modal
Widget _buildModalButton({
  required String label,
  required VoidCallback onTap,
}) {
  final Color cardColor = const Color(0xFF885053); // Button color
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Less roundy corners
        ),
        padding: const EdgeInsets.symmetric(vertical: 15), // Adjust height
        fixedSize: const Size(277, 55), // Set fixed size for width and height
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
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