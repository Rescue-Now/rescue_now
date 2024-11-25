import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Profile data variables
  String name = 'Antonel';
  int age = 21;
  String bloodGroup = 'A-';
  String allergies = 'oua, parul de pisica';

  // Edit mode flag
  bool isEditing = false;

  // Controllers for text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();
  final TextEditingController allergiesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current values
    nameController.text = name;
    ageController.text = age.toString();
    bloodGroupController.text = bloodGroup;
    allergiesController.text = allergies;
  }

  @override
  void dispose() {
    // Dispose of controllers when the widget is removed
    nameController.dispose();
    ageController.dispose();
    bloodGroupController.dispose();
    allergiesController.dispose();
    super.dispose();
  }

  // Function to toggle edit mode
  void toggleEditMode() {
    setState(() {
      isEditing = !isEditing;
      if (!isEditing) {
        // Save changes if switching out of edit mode
        saveProfile();
      }
    });
  }

  // Function to save profile details
  void saveProfile() {
    setState(() {
      name = nameController.text;
      age = int.tryParse(ageController.text) ?? age; // Keep old value if parsing fails
      bloodGroup = bloodGroupController.text;
      allergies = allergiesController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAA798), // HEX #eaa798
      body: Column(
        children: [
          const SizedBox(height: 24),
          // Top Bar with Back Button and Centered Title
          Stack(
            children: [
              // Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: const Color(0xFF4C3527), // HEX #4c3527
                    size: 24,
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Go back to the previous page
                  },
                ),
              ),
              // Centered Title
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Profile',
                  style: TextStyle(
                    fontFamily: 'Source Sans Pro',
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4C3527), // HEX #4c3527
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          // Profile picture
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(45), // Rectangle with rounded corners
              child: Container(
                width: 144,
                height: 159.58,
                color: Colors.black, // Placeholder background
                child: Image.asset(
                  'assets/profile_pic.jpg', // Add your profile image path here
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Name under profile picture
          Center(
            child: isEditing
                ? SizedBox(
              width: 200, // Adjustable width for the input
              child: TextField(
                controller: nameController,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Source Sans Pro',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4C3527), // HEX #4c3527
                ),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Enter Name',
                ),
              ),
            )
                : Text(
              name,
              style: TextStyle(
                fontFamily: 'Source Sans Pro',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4C3527), // HEX #4c3527
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Profile details: Age, Blood Type, Allergies
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileDetail(
                  label: "Age",
                  value: isEditing
                      ? TextField(
                    controller: ageController,
                    style: TextStyle(
                      fontFamily: 'Source Sans Pro',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF885053), // HEX #885053
                    ),
                    keyboardType: TextInputType.number,
                  )
                      : Text(
                    age.toString(),
                    style: TextStyle(
                      fontFamily: 'Source Sans Pro',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF885053), // HEX #885053
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ProfileDetail(
                  label: "Blood Type",
                  value: isEditing
                      ? TextField(
                    controller: bloodGroupController,
                    style: TextStyle(
                      fontFamily: 'Source Sans Pro',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF885053), // HEX #885053
                    ),
                  )
                      : Text(
                    bloodGroup,
                    style: TextStyle(
                      fontFamily: 'Source Sans Pro',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF885053), // HEX #885053
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ProfileDetail(
                  label: "Allergies",
                  value: isEditing
                      ? TextField(
                    controller: allergiesController,
                    style: TextStyle(
                      fontFamily: 'Source Sans Pro',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF885053), // HEX #885053
                    ),
                  )
                      : Text(
                    allergies,
                    style: TextStyle(
                      fontFamily: 'Source Sans Pro',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF885053), // HEX #885053
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Rounded Edit Profile Button
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF4C3527), // Button color HEX #4c3527
                borderRadius: BorderRadius.circular(24), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4), // 40% shadow opacity
                    offset: const Offset(0, 6), // Drop shadow with downward offset
                    blurRadius: 12, // Smooth blur
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: toggleEditMode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4C3527), // HEX #4c3527
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24), // More rounded corners
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  minimumSize: const Size(144.25, 48), // W:144.25, H:48
                ),
                child: Text(
                  isEditing ? 'Save Changes' : 'Edit',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Text color HEX #ffffff
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ",
          style: TextStyle(
            fontFamily: 'Source Sans Pro',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4C3527), // HEX #4c3527
          ),
        ),
        Expanded(child: value),
      ],
    );
  }
}
