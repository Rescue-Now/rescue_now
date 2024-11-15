import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Declare variables to hold the profile data
  String name = 'John Doe';
  int age = 30;
  String bloodGroup = 'O+';
  String allergies = 'Peanuts, Shellfish';
//
  // Declare controllers for the text fields
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController();
  TextEditingController allergiesController = TextEditingController();

  // Edit mode flag
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with current values
    nameController.text = name;
    ageController.text = age.toString();
    bloodGroupController.text = bloodGroup;
    allergiesController.text = allergies;
  }

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    nameController.dispose();
    ageController.dispose();
    bloodGroupController.dispose();
    allergiesController.dispose();
    super.dispose();
  }
//
  void toggleEditMode() {
    setState(() {
      isEditing = !isEditing;
    });
  }
//
  void saveProfile() {
    setState(() {
      name = nameController.text;
      age = int.tryParse(ageController.text) ?? age;
      bloodGroup = bloodGroupController.text;
      allergies = allergiesController.text;
      isEditing = false; // Stop editing after save
    });
  }
//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/profile_pic.jpg'),
            ),
            const SizedBox(height: 20),

            // Profile Details
            ProfileDetail(
              label: "Name",
              value: isEditing
                  ? TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: 'Enter your name'),
              )
                  : Text(name),
            ),
            ProfileDetail(
              label: "Age",
              value: isEditing
                  ? TextField(
                controller: ageController,
                decoration: InputDecoration(hintText: 'Enter your age'),
              )
                  : Text(age.toString()),
            ),
            ProfileDetail(
              label: "Blood Group",
              value: isEditing
                  ? TextField(
                controller: bloodGroupController,
                decoration: InputDecoration(hintText: 'Enter your blood group'),
              )
                  : Text(bloodGroup),
            ),
            ProfileDetail(
              label: "Allergies",
              value: isEditing
                  ? TextField(
                controller: allergiesController,
                decoration: InputDecoration(hintText: 'Enter your allergies'),
              )
                  : Text(allergies),
            ),

            // Edit/Save Button
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isEditing ? saveProfile : toggleEditMode,
              child: Text(isEditing ? 'Save Changes' : 'Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileDetail extends StatelessWidget {
  final String label;
  final Widget value;

  const ProfileDetail({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Expanded(child: value),
        ],
      ),
    );
  }
}
