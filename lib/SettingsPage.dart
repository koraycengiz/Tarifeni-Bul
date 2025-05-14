import 'package:feng498/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ProfilePage.dart';
import 'TariffProvider.dart';
import 'UserDataProvider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String dropdownSelectedOperator = "Select Current Operator";

  @override
  void initState() {
    super.initState();
    // Example: Prefill with current user info
    _usernameController.text = "...";
    _emailController.text = "...";
  }

  void _saveSettings() {
    String newUsername = _usernameController.text.trim();
    String newEmail = _emailController.text.trim();
    String newPassword = _passwordController.text.trim();

    // You can add logic here to validate and update user data
    print("Username: $newUsername");
    print("Email: $newEmail");
    print("Password: $newPassword");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Settings saved successfully!")),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildTextField('Username', _usernameController),
            SizedBox(height: 16),
            _buildTextField('Email', _emailController),
            SizedBox(height: 16),
            _buildTextField('Password (optional)', _passwordController, isPassword: true),

            DropdownButton<String>(
              value: userDataProvider.selectedOperator,
              items: ["Vodafone", "Turkcell", "Türk Telekom", "Select Current Operator"]
                  .map((op) => DropdownMenuItem(value: op, child: Text(op)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  userDataProvider.setSelectedOperator(value);
                }
              },
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
