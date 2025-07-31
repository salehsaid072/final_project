import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  bool notificationsEnabled = true;
  bool locationEnabled = true;
  String language = 'English';
  String currency = 'TZS';
  double textSize = 1.0; // 1.0 is normal size

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('dark_mode') ?? false;
      notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      locationEnabled = prefs.getBool('location_enabled') ?? true;
      language = prefs.getString('language') ?? 'English';
      currency = prefs.getString('currency') ?? 'TZS';
      textSize = prefs.getDouble('text_size') ?? 1.0;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', isDarkMode);
    await prefs.setBool('notifications_enabled', notificationsEnabled);
    await prefs.setBool('location_enabled', locationEnabled);
    await prefs.setString('language', language);
    await prefs.setString('currency', currency);
    await prefs.setDouble('text_size', textSize);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSettings,
            tooltip: 'Save Settings',
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildHeader(),
          _buildSectionTitle('Appearance'),
          _buildSwitchTile(
            'Dark Mode',
            'Toggle between light and dark theme',
            Icons.brightness_4,
            isDarkMode,
            (value) {
              setState(() {
                isDarkMode = value;
              });
            },
          ),
          _buildSliderTile(
            'Text Size',
            'Adjust the size of text throughout the app',
            Icons.text_fields,
            textSize,
            (value) {
              setState(() {
                textSize = value;
              });
            },
          ),
          _buildSectionTitle('Notifications'),
          _buildSwitchTile(
            'Enable Notifications',
            'Receive alerts about orders and updates',
            Icons.notifications,
            notificationsEnabled,
            (value) {
              setState(() {
                notificationsEnabled = value;
              });
            },
          ),
          _buildSectionTitle('Location & Privacy'),
          _buildSwitchTile(
            'Enable Location',
            'Allow app to access your location for delivery',
            Icons.location_on,
            locationEnabled,
            (value) {
              setState(() {
                locationEnabled = value;
              });
            },
          ),
          _buildSectionTitle('Regional Settings'),
          _buildDropdownTile(
            'Language',
            'Select your preferred language',
            Icons.language,
            language,
            ['English', 'Swahili', 'French'],
            (newValue) {
              setState(() {
                language = newValue!;
              });
            },
          ),
          _buildDropdownTile(
            'Currency',
            'Select your preferred currency',
            Icons.attach_money,
            currency,
            ['TZS', 'USD', 'EUR', 'KES'],
            (newValue) {
              setState(() {
                currency = newValue!;
              });
            },
          ),
          _buildSectionTitle('Account'),
          _buildNavigationTile(
            'Edit Profile',
            'Update your personal information',
            Icons.person,
            () => Navigator.pushNamed(context, '/profile'),
          ),
          _buildNavigationTile(
            'Change Password',
            'Update your account password',
            Icons.lock,
            () {
              // Show change password dialog
              _showChangePasswordDialog();
            },
          ),
          _buildNavigationTile(
            'Privacy Policy',
            'Read our privacy policy',
            Icons.privacy_tip,
            () {
              // Navigate to privacy policy page
            },
          ),
          _buildNavigationTile(
            'Terms of Service',
            'Read our terms of service',
            Icons.description,
            () {
              // Navigate to terms of service page
            },
          ),
          _buildNavigationTile(
            'Help & Support',
            'Get help and contact our support team',
            Icons.help,
            () {
              Navigator.pushNamed(context, '/help_support');
            },
          ),
          _buildNavigationTile(
            'Logout',
            'Sign out of your account',
            Icons.exit_to_app,
            () {
              _showLogoutConfirmDialog();
            },
            color: Colors.red,
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'AgriMarket Hub v1.0.0',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.teal.withOpacity(0.1),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.teal.shade200,
            child: Icon(Icons.settings, size: 30, color: Colors.teal.shade800),
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'App Settings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'Customize your app experience',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal.shade800),
          ),
          Divider(color: Colors.teal.shade200),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.teal,
      ),
    );
  }

  Widget _buildSliderTile(String title, String subtitle, IconData icon, double value, Function(double) onChanged) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle),
          Slider(
            value: value,
            min: 0.8,
            max: 1.2,
            divisions: 4,
            label: value == 0.8 ? 'Small' : value == 1.0 ? 'Normal' : 'Large',
            onChanged: onChanged,
            activeColor: Colors.teal,
          ),
        ],
      ),
      isThreeLine: true,
    );
  }

  Widget _buildDropdownTile(String title, String subtitle, IconData icon, String value, List<String> options, Function(String?) onChanged) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        items: options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        underline: Container(),
      ),
    );
  }

  Widget _buildNavigationTile(String title, String subtitle, IconData icon, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.teal),
      title: Text(title, style: TextStyle(color: color)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showChangePasswordDialog() {
    final TextEditingController currentPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                decoration: const InputDecoration(labelText: 'Current Password'),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newPasswordController,
                decoration: const InputDecoration(labelText: 'New Password'),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(labelText: 'Confirm New Password'),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Validate passwords
              if (newPasswordController.text != confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Passwords do not match')),
                );
                return;
              }
              
              // Here you would implement password change logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password changed successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}