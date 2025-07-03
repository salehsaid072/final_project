import 'package:flutter/material.dart';

class FarmerHomePage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final String username = ModalRoute.of(context)?.settings.arguments as String? ?? 'Farmer';

    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 30),
            SizedBox(width: 10),
            Text('AgriMarket Hub'),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Help & Support',
            onPressed: () {
              try {
                Navigator.pushNamed(context, '/help_support');
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error opening Help & Support: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          PopupMenuButton<String>(
            onSelected: (String choice) {
              try {
                if (choice == 'Settings') {
                  Navigator.pushNamed(context, '/settings');
                } else if (choice == 'About Us') {
                  Navigator.pushNamed(context, '/about_us');
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error opening $choice: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return const [
                PopupMenuItem<String>(
                  value: 'Settings',
                  child: Text('Settings'),
                ),
                PopupMenuItem<String>(
                  value: 'About Us',
                  child: Text('About Us'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset('assets/images/logo.png', height: 80),
                  SizedBox(height: 20),
                  Text(
                    'Welcome, $username!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Manage your product, order, and transaction for easy.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildGridBox(context, 'Products', Icons.store, Colors.green, '/products'),
                  _buildGridBox(context, 'Orders', Icons.shopping_cart, Colors.blue, '/orders'),
                  _buildGridBox(context, 'Transactions', Icons.payment, Colors.orange, '/transactions'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
        ],
        onTap: (index) {
          try {
            if (index == 0) {
              Navigator.pushNamed(context, '/farmer_home');
            } else if (index == 1) {
              Navigator.pushNamed(context, '/profile');
            } else if (index == 2) {
              Navigator.pushNamed(context, '/notifications');
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error navigating to page: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildGridBox(BuildContext context, String title, IconData icon, Color color, String route) {
    return InkWell(
      onTap: () {
        try {
          Navigator.pushNamed(context, route);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error navigating to $title: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Card(
        color: color.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}