import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rescue_now_app/src/contacts.dart';
import 'package:rescue_now_app/src/crash_detection.dart';
import 'package:rescue_now_app/src/location_management.dart'; // ee n-ar trebui sa fie unusued da las ne mai auizim noi
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'src/firebase_options.dart';
import 'src/patient.dart';
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
  late Position position;

  Future<void> callEmergencyNumber() async {
    const String emergencyNumber = '0760068619';
    final Uri telUri = Uri(
      scheme: 'tel',
      path: emergencyNumber,
    );

    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      print('Could not launch Phone Call to $emergencyNumber');
    }
  }

  Future<void> _getSendLocationSetState() async {
    setState(() async {
      position = await getAndSendLocation();
    });
  }

  void _onLongPressStart() {
    setState(() {
      _isHolding = true;
      _buttonSize = 160.0;
    });

    _timer = Timer(const Duration(seconds: 1), () {
      if (_isHolding) {
        _getSendLocationSetState();
        _showEmergencyMessage();
        callEmergencyNumber();
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

  void _showNoContactsSavedMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("No contacts saved"),
        content: const Text("Please save an emergency contact"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ContactsScreen(),
                ),
              );
            },
            child: const Text("Go to contacts"),
          ),
        ],
      ),
    );
  }

  void _showEmergencyMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Emergency"),
        content: const Text("Calling Authorities..."),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ContactsScreen(),
                        ),
                      );
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
                        _getSendLocationSetState();
                        _textEmergencyContact();
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                    _buildModalButton(
                      label: 'Voice Emergency Call',
                      onTap: () {
                        _getSendLocationSetState();
                        initiateVoiceCall();
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                    _buildModalButton(
                      label: 'Video Emergency Call',
                      onTap: () {
                        _getSendLocationSetState();
                        initiateVideoCall();
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
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

  String _convertListForMessage(List<String> list) {
    return list.toString().replaceAll(RegExp(r'[\[\]]'), '');
  }

  Future<void> _textEmergencyContact() async {
    print('Sending text to contact');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? contactNumber = prefs.getString('emergencyContactNumber');

    if (contactNumber == null) {
      _showNoContactsSavedMessage();
      print('No emergency contact saved.');
    } else {
      // get current location from patient in sharedprefferences

      Patient? patient;

      SharedPreferencesAsync prefs = SharedPreferencesAsync();
      String? patientJson = await prefs.getString('patientData');
      if (patientJson != null) {
        patient = Patient.fromJson(json.decode(patientJson));
      }

      final String message = """These are my coordinates: 
latitude: ${position.latitude}
longitude: ${position.longitude}
${patient?.age != 0 ? "I'm " + patient!.age.toString() + " years old" : ''}
${patient?.bloodGroup != "" ? 'My blood type is:' + patient!.bloodGroup : ''}
${patient?.knownAllergies[0] != "" ? "I'm allergic to:" + _convertListForMessage(patient!.knownAllergies) : ''}
${patient?.conditions[0] != "" ? 'My conditions are:' + _convertListForMessage(patient!.conditions) : ''}
${patient?.medicalHistory[0] != "" ? 'My medical history being:' + _convertListForMessage(patient!.medicalHistory) : ''}
""";

      final Uri smsUri = Uri.parse("sms:$contactNumber?body=$message");

      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      } else {
        print('Could not launch SMS to $contactNumber');
      }
    }
  }

  Future<void> initiateVoiceCall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? contactNumber = prefs.getString('emergencyContactNumber');

    if (contactNumber == null) {
      print('No emergency contact saved.');
    } else {
      final Uri telUri = Uri(scheme: 'tel', path: contactNumber);
      if (await canLaunchUrl(telUri)) {
        await launchUrl(telUri);
      } else {
        print('Could not launch Phone Call to $contactNumber');
      }
    }
  }

  Future<void> initiateVideoCall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? contactNumber = prefs.getString('emergencyContactNumber');

    if (contactNumber == null) {
      print('No emergency contact saved.');
    } else {
      final Uri videoCallUri = Uri(
        scheme: 'facetime',
        // Schimbă cu schema dorită pentru Android, dacă este cazul.
        path: contactNumber,
      );
      if (await canLaunchUrl(videoCallUri)) {
        await launchUrl(videoCallUri);
      } else {
        print('Could not launch Video Call to $contactNumber');
      }
    }
  }
}
