import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  bool isLoading = true;
  String? savedName;
  String? savedNumber;

  @override
  void initState() {
    super.initState();
    _loadEmergencyContact();
  }

  @override
  void dispose() {
    _contactNameController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }

  Future<void> _loadEmergencyContact() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      savedName = prefs.getString('emergencyContactName');
      savedNumber = prefs.getString('emergencyContactNumber');
      isLoading = false;
    });
  }

  Future<void> _saveEmergencyContact() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('emergencyContactName', _contactNameController.text);
    await prefs.setString('emergencyContactNumber', _contactNumberController.text);
    setState(() {
      savedName = _contactNameController.text;
      savedNumber = _contactNumberController.text;
    });
  }

  void _editContact() {
    setState(() {
      _contactNameController.text = savedName ?? '';
      _contactNumberController.text = savedNumber ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.colors.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.colors.background,
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
        backgroundColor: AppTheme.colors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Emergency Contact',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.colors.menuButtons,
              ),
            ),
            const SizedBox(height: 16),
            savedName != null && savedNumber != null
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name: $savedName',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Number: $savedNumber',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _editContact,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.colors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text('Edit Contact'),
                ),
              ],
            )
                : const Text('No emergency contact saved yet.'),
            const SizedBox(height: 24),
            TextField(
              controller: _contactNameController,
              decoration: const InputDecoration(
                labelText: 'Contact Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contactNumberController,
              decoration: const InputDecoration(
                labelText: 'Contact Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveEmergencyContact,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.colors.menuButtons,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text('Save Contact'),
            ),
          ],
        ),
      ),
    );
  }
}