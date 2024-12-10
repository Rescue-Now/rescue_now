import 'package:flutter/material.dart';
import '../theme/app_theme.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = 'Antonel';
  int age = 21;
  String bloodGroup = 'A-';
  String allergies = 'oua, parul de pisica';

  bool isEditing = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();
  final TextEditingController allergiesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = name;
    ageController.text = age.toString();
    bloodGroupController.text = bloodGroup;
    allergiesController.text = allergies;
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    bloodGroupController.dispose();
    allergiesController.dispose();
    super.dispose();
  }

  void toggleEditMode() {
    setState(() {
      isEditing = !isEditing;
      if (!isEditing) saveProfile();
    });
  }

  void saveProfile() {
    setState(() {
      name = nameController.text;
      age = int.tryParse(ageController.text) ?? age;
      bloodGroup = bloodGroupController.text;
      allergies = allergiesController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  ? SizedBox(
                width: 200,
                child: TextField(
                  controller: nameController,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Source Sans Pro',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.colors.menuButtons,
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
                  color: AppTheme.colors.menuButtons,
                ),
              ),
            ),
            const SizedBox(height: 40),
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
                        color: AppTheme.colors.menuButtons,
                      ),
                      keyboardType: TextInputType.number,
                    )
                        : Text(
                      age.toString(),
                      style: TextStyle(
                        fontFamily: 'Source Sans Pro',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.colors.menuButtons,
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
                        color: AppTheme.colors.menuButtons,
                      ),
                    )
                        : Text(
                      bloodGroup,
                      style: TextStyle(
                        fontFamily: 'Source Sans Pro',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.colors.menuButtons,
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
                        color: AppTheme.colors.menuButtons,
                      ),
                    )
                        : Text(
                      allergies,
                      style: TextStyle(
                        fontFamily: 'Source Sans Pro',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.colors.menuButtons,
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
                  color: AppTheme.colors.menuButtons,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      offset: const Offset(0, 6),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: toggleEditMode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.colors.menuButtons,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    minimumSize: const Size(144.25, 48),
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
            ),
            const SizedBox(height: 40),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ",
          style: TextStyle(
            fontFamily: 'Source Sans Pro',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.colors.menuButtons,
          ),
        ),
        Expanded(child: value),
      ],
    );
  }
}
