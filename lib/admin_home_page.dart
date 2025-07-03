import 'package:flutter/material.dart';
import 'user_verification_page.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 30), // Logo ndogo kwenye AppBar
            SizedBox(width: 10),
            Text(
              'AgriMarket Hub - Admin',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            tooltip: 'Help & Support',
            onPressed: () {
              Navigator.pushNamed(context, '/help_support');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.teal),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Admin Panel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'admin@agrimarket.com',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard, color: Colors.teal),
              title: Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.analytics, color: Colors.teal),
              title: Text('Analytics'),
              onTap: () {
                try {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/admin_login');
              Navigator.of(context).popUntil((route) => route.isFirst);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error navigating to Analytics: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.category, color: Colors.teal),
              title: Text('Categories'),
              onTap: () {
                try {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/categories');
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error navigating to Categories: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.people, color: Colors.teal),
              title: Text('Manage Users'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/manage_users');
              },
            ),
            ListTile(
              leading: Icon(Icons.verified_user, color: Colors.teal),
              title: Text('User Verification'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/user_verification');
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag, color: Colors.teal),
              title: Text('Products'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/products');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.grey),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/admin_login');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset('assets/images/logo.png', height: 80), // Logo kubwa
                  SizedBox(height: 20),
                  Text(
                    'Welcome, Admin!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Manage all aspects of your marketplace from here.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Quick Actions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildAdminCard(
                    context,
                    'Analytics',
                    Icons.analytics,
                    Colors.blue,
                    'View sales and user statistics',
                    () => Navigator.pushNamed(context, '/analytics'),
                  ),
                  _buildAdminCard(
                    context,
                    'Manage Users',
                    Icons.people,
                    Colors.orange,
                    'View and manage all users',
                    () => Navigator.pushNamed(context, '/manage_users'),
                  ),
                  _buildAdminCard(
                    context,
                    'Categories',
                    Icons.category,
                    Colors.green,
                    'Manage product categories',
                    () => Navigator.pushNamed(context, '/categories'),
                  ),
                  _buildAdminCard(
                    context,
                    'User Verification',
                    Icons.verified_user,
                    Colors.purple,
                    'Verify new user registrations',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserVerificationPage()),
                    ),
                  ),
                  _buildAdminCard(
                    context,
                    'Products',
                    Icons.shopping_bag,
                    Colors.amber,
                    'Manage all marketplace products',
                    () => Navigator.pushNamed(context, '/products'),
                  ),
                  _buildAdminCard(
                    context,
                    'Settings',
                    Icons.settings,
                    Colors.grey,
                    'Configure application settings',
                    () => Navigator.pushNamed(context, '/settings'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String description,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Flexible(
                child: Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}