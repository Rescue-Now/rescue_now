import 'package:flutter/material.dart';
import 'package:rescue_now_app/src/patient.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Patient patient;
  bool isEditing = false;
  bool isLoading = true;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();
  final TextEditingController allergiesController = TextEditingController();
  final TextEditingController conditionsController = TextEditingController();
  final TextEditingController medicalHistoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPatientData();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    ageController.dispose();
    bloodGroupController.dispose();
    allergiesController.dispose();
    conditionsController.dispose();
    medicalHistoryController.dispose();
    super.dispose();
  }

  Future<void> _loadPatientData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? patientJson = prefs.getString('patientData');

    if (patientJson != null) {
      patient = Patient.fromJson(json.decode(patientJson));
    } else {
      patient = Patient(
        id: '1',
        firstName: 'Antonel',
        lastName: 'Ionescu',
        age: 21,
        bloodGroup: 'A-',
        knownAllergies: ['Eggs', 'Cat hair'],
        conditions: ['Diabetes'],
        medicalHistory: ['Appendectomy'],
      );
    }

    firstNameController.text = patient.firstName;
    lastNameController.text = patient.lastName;
    ageController.text = patient.age.toString();
    bloodGroupController.text = patient.bloodGroup;
    allergiesController.text = patient.knownAllergies.join(', ');
    conditionsController.text = patient.conditions.join(', ');
    medicalHistoryController.text = patient.medicalHistory.join(', ');

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _savePatientData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    patient.firstName = firstNameController.text;
    patient.lastName = lastNameController.text;
    patient.age = int.tryParse(ageController.text) ?? patient.age;
    patient.bloodGroup = bloodGroupController.text;
    patient.knownAllergies = allergiesController.text.split(',').map((e) => e.trim()).toList();
    patient.conditions = conditionsController.text.split(',').map((e) => e.trim()).toList();
    patient.medicalHistory = medicalHistoryController.text.split(',').map((e) => e.trim()).toList();

    await prefs.setString('patientData', json.encode(patient.toJson()));
  }

  void toggleEditMode() {
    setState(() {
      isEditing = !isEditing;
      if (!isEditing) {
        _savePatientData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.colors.background,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: AppTheme.colors.menuButtons,
                      iconSize: 32,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Profile',
                      style: TextStyle(
                        fontFamily: 'Source Sans Pro',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.colors.menuButtons,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(45),
                child: Container(
                  width: 144,
                  height: 159.58,
                  color: Colors.black,
                  child: Image.asset(
                    'assets/profile_pic.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: isEditing
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: TextField(
                      controller: firstNameController,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Source Sans Pro',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.colors.menuButtons,
                      ),
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'First Name',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: TextField(
                      controller: lastNameController,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Source Sans Pro',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.colors.menuButtons,
                      ),
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'Last Name',
                      ),
                    ),
                  ),
                ],
              )
                  : Text(
                '${patient.firstName} ${patient.lastName}',
                style: TextStyle(
                  fontFamily: 'Source Sans Pro',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.colors.menuButtons,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                children: [
                  _buildEditableField('Age', ageController, isNumber: true),
                  const SizedBox(height: 20),
                  _buildEditableField('Blood Type', bloodGroupController),
                  const SizedBox(height: 20),
                  _buildEditableField('Allergies', allergiesController),
                  const SizedBox(height: 20),
                  _buildEditableField('Conditions', conditionsController),
                  const SizedBox(height: 20),
                  _buildEditableField('Medical History', medicalHistoryController),
                ],
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: toggleEditMode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.colors.menuButtons,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                ),
                child: Text(
                  isEditing ? 'Save Changes' : 'Edit',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller, {bool isNumber = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            "$label: ",
            style: TextStyle(
              fontFamily: 'Source Sans Pro',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.colors.menuButtons,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: isEditing
              ? TextField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            style: TextStyle(
              fontFamily: 'Source Sans Pro',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.colors.menuButtons,
            ),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            ),
          )
              : Text(
            controller.text,
            style: TextStyle(
              fontFamily: 'Source Sans Pro',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.colors.menuButtons,
            ),
            maxLines: null,
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
