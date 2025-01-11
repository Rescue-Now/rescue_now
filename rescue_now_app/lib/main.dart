import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rescue_now_app/src/crash_detection.dart';
import 'package:rescue_now_app/src/location_management.dart';
import 'package:url_launcher/url_launcher.dart';
import 'src/firebase_options.dart';
import 'src/profile_screen.dart';
import 'theme/app_theme.dart';

// ignore_for_file: avoid_print
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';

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
  double _buttonSize = 145.0;
  Timer? _timer;
  bool _isHolding = false;

  void sendSOSAlert() {
    print("SOS alert has been sent!");
  }

  void _onLongPressStart() {
    setState(() {
      _isHolding = true;
      _buttonSize = 160.0;
    });

    _timer = Timer(const Duration(seconds: 1), () {
      if (_isHolding) {
        sendSOSAlert();
        _showEmergencyMessage();
      }
    });
  }

  void _onLongPressEnd() {
    setState(() {
      _isHolding = false;
      _buttonSize = 145.0;
    });
    _timer?.cancel();
  }

  void _showEmergencyMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Emergency"),
        content: const Text("Calling Emergency Something..."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

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
              onLongPressStart: (_) => _onLongPressStart(),
              onLongPressEnd: (_) => _onLongPressEnd(),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: _buttonSize,
                width: _buttonSize,
                decoration: BoxDecoration(
                  color: AppTheme.colors.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                // butonul de sos
                child: Center(
                  child: SvgPicture.asset(
                    'assets/sos_button.svg',
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
    const String emergencyPhoneNumber = '0760068619';

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
                          sendSOSAlert();
                          textEmergencyContacts(emergencyPhoneNumber);
                          Navigator.pop(context);
                      },
                    ),
                    _buildModalButton(
                      label: 'Voice Emergency Call',
                      onTap: () {
                        sendSOSAlert();
                        initiateVoiceCall(emergencyPhoneNumber);
                        Navigator.pop(context);
                      },
                    ),
                    _buildModalButton(
                      label: 'Video Emergency Call',
                      onTap: () {
                        sendSOSAlert();
                        initiateVideoCall(emergencyPhoneNumber);
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
                          style: TextStyle(
                              color: AppTheme.colors.text,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
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
          style: TextStyle(
            color: AppTheme.colors.text,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  void textEmergencyContacts(String phoneNumber) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      query: 'body=This is an emergency! Please help.',
    );

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      print('Could not launch SMS');
    }
  }

  // Asta gen porneste sa incepi sa vorebesti cu aia de la 112, NU cu contactele
  void initiateTextConversation() {
    print('Asta gen porneste sa incepi sa vorebesti cu aia de la 112, NU cu contactele');
  }

  void initiateVoiceCall(String phoneNumber) async {
    final Uri telUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      print('Could not launch Phone Call');
    }
  }

  void initiateVideoCall(String phoneNumber) async {
    final Uri videoCallUri = Uri(
      scheme: 'facetime',
      path: phoneNumber, // Pentru iOS se poate folosi FaceTime.
    );

    if (await canLaunchUrl(videoCallUri)) {
      await launchUrl(videoCallUri);
    } else {
      print('Could not launch Video Call');
    }
  }
}
