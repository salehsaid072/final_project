import 'package:flutter/material.dart';

class ManageUsersPage extends StatelessWidget {
  final List<Map<String, String>> users = [
    {'fullName': 'John Doe', 'email': 'john@example.com', 'address': 'Dar es Salaam', 'userType': 'Farmer', 'username': 'johndoe', 'password': 'password123'},
    {'fullName': 'Jane Smith', 'email': 'jane@example.com', 'address': 'Mwanza', 'userType': 'Buyer', 'username': 'janesmith', 'password': 'buyerpass'},
  ];

   ManageUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            border: TableBorder.all(color: Colors.teal, width: 1), // Ongeza border kwenye table
            headingRowColor: WidgetStateProperty.all(Colors.teal.shade100), // Rangi ya vichwa vya table
            columns: [
              const DataColumn(label: Text('Full Name', style: TextStyle(fontWeight: FontWeight.bold))),
              const DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
              const DataColumn(label: Text('Address', style: TextStyle(fontWeight: FontWeight.bold))),
              const DataColumn(label: Text('User Type', style: TextStyle(fontWeight: FontWeight.bold))),
              const DataColumn(label: Text('Username', style: TextStyle(fontWeight: FontWeight.bold))),
              const DataColumn(label: Text('Password', style: TextStyle(fontWeight: FontWeight.bold))),
              const DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: users.map((user) {
              return DataRow(
                cells: [
                  DataCell(Text(user['fullName']!)),
                  DataCell(Text(user['email']!)),
                  DataCell(Text(user['address']!)),
                  DataCell(Text(user['userType']!)),
                  DataCell(Text(user['username']!)),
                  DataCell(Text(user['password']!)),
                  DataCell(
                    Row(
                      children: [
                        IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () {}),
                        IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () {}),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}