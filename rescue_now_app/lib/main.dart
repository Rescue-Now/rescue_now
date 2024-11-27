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
        height: 40,  
        width: 40,   
        child: SvgPicture.asset(
          'assets/info svg-2.svg', 
          fit: BoxFit.contain,  
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
    backgroundColor: AppTheme.colors.background,
    body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, 
              children: [
                const SizedBox(width: 16), 
                _buildIconWithLabel(
                  icon: SvgPicture.asset(
                    'assets/emergency-contacts.svg',
                    height: 40,
                    width: 40,
                  ),
                  label: 'Contacts',
                  onTap: () {
                    print('Contacts tapped');
                  },
                ),
                
                const SizedBox(width: 24), 

                _buildIconWithLabel(
                  icon: SvgPicture.asset(
                    'assets/crash.svg',
                    height: 40,
                    width: 40,
                  ),
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
                const Spacer(), 
                Padding(
                  padding: const EdgeInsets.only(right: 20.0), 
                  child: _buildIconWithLabel(
                    icon: SvgPicture.asset(
                      'assets/profile.svg',
                      color: AppTheme.colors.menuButtons,
                      height: 40,
                      width: 40,
                    ),
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
                ),
              ],
            ),
          ),
            GestureDetector(
              child: Container(
                height: 120,  
                width: 120,
                decoration: BoxDecoration(
                  color: AppTheme.colors.primary,
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
Padding(
  padding: const EdgeInsets.only(bottom: 20.0),
  child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20), 
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3), 
          spreadRadius: 2, 
          blurRadius: 6,  
          offset: Offset(0, 3), 
        ),
      ],
    ),
    child: ElevatedButton(
      onPressed: () {
        showEmergencyMenu(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.colors.menuButtons,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), 
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
      ),
      child: Text(
        'Help options',
        style: TextStyle(
          color: AppTheme.colors.text,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
),

          ],
        ),
      ),
    );
  }
  Widget _buildIconWithLabel({
  required Widget icon, 
  required String label,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        icon, 
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: AppTheme.colors.menuButtons,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

void showEmergencyMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(50.0),  
        topRight: Radius.circular(50.0), 
      ),
    ),
    builder: (BuildContext context) {
      return Container(

        decoration: BoxDecoration(
          color: AppTheme.colors.menuButtons, 
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.0),  
            topRight: Radius.circular(50.0), 
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: AppTheme.colors.text, 
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
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
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20.0),
  child: Row(
    mainAxisSize: MainAxisSize.min, 
    crossAxisAlignment: CrossAxisAlignment.center, 
    children: [
      FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          height: 40, 
          width: 40,  
          child: SvgPicture.asset(
            'assets/info svg-2.svg',
          ),
        ),
      ),
      const SizedBox(width: 2), 
      Expanded(
        child: Text(
          'Initiating any kind of help request will also alert emergency contacts.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppTheme.colors.text, fontSize: 16, fontWeight: FontWeight.bold)
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
Widget _buildModalButton({
  required String label,
  required VoidCallback onTap,
}) {
  final Color cardColor = AppTheme.colors.primary; 
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), 
        ),
        padding: const EdgeInsets.symmetric(vertical: 15), 
        fixedSize: const Size(277, 55), 
      ),
      child: Text(
        label,
        style: TextStyle(color: AppTheme.colors.text, fontSize: 18,
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