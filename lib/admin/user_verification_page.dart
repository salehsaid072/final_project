import 'package:flutter/material.dart';

class UserVerificationPage extends StatefulWidget {
  const UserVerificationPage({super.key});

  @override
  _UserVerificationPageState createState() => _UserVerificationPageState();
}

class _UserVerificationPageState extends State<UserVerificationPage> {
  final List<Map<String, dynamic>> pendingUsers = [
    {
      'id': '001',
      'name': 'Ibrahim Hassan',
      'email': 'ibrahim@example.com',
      'userType': 'Farmer',
      'address': 'Morogoro',
      'documents': ['ID Card', 'Business License'],
      'status': 'Pending',
      'registrationDate': '2025-05-10',
    },
    {
      'id': '002',
      'name': 'Amina Juma',
      'email': 'amina@example.com',
      'userType': 'Buyer',
      'address': 'Arusha',
      'documents': ['ID Card'],
      'status': 'Pending',
      'registrationDate': '2025-05-12',
    },
    {
      'id': '003',
      'name': 'David Mwakasege',
      'email': 'david@example.com',
      'userType': 'Farmer',
      'address': 'Dodoma',
      'documents': ['ID Card', 'Farm Certificate'],
      'status': 'Pending',
      'registrationDate': '2025-05-14',
    },
  ];

  List<Map<String, dynamic>> filteredUsers = [];
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    filteredUsers = List.from(pendingUsers);
  }

  void _filterUsers(String filter) {
    setState(() {
      selectedFilter = filter;
      if (filter == 'All') {
        filteredUsers = List.from(pendingUsers);
      } else {
        filteredUsers = pendingUsers.where((user) => user['userType'] == filter).toList();
      }
    });
  }

  void _verifyUser(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verify User'),
        content: Text('Are you sure you want to verify ${filteredUsers[index]['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                // Find the original index in the pendingUsers list
                final originalIndex = pendingUsers.indexWhere(
                    (user) => user['id'] == filteredUsers[index]['id']);
                if (originalIndex != -1) {
                  pendingUsers[originalIndex]['status'] = 'Verified';
                  filteredUsers[index]['status'] = 'Verified';
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User verified successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }

  void _rejectUser(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Are you sure you want to reject ${filteredUsers[index]['name']}?'),
            const SizedBox(height: 10),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Reason for rejection',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                // Find the original index in the pendingUsers list
                final originalIndex = pendingUsers.indexWhere(
                    (user) => user['id'] == filteredUsers[index]['id']);
                if (originalIndex != -1) {
                  pendingUsers[originalIndex]['status'] = 'Rejected';
                  filteredUsers[index]['status'] = 'Rejected';
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User rejected')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  void _viewUserDetails(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('User Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('ID', user['id']),
              _buildDetailRow('Name', user['name']),
              _buildDetailRow('Email', user['email']),
              _buildDetailRow('User Type', user['userType']),
              _buildDetailRow('Address', user['address']),
              _buildDetailRow('Registration Date', user['registrationDate']),
              const SizedBox(height: 10),
              const Text('Submitted Documents:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              ...user['documents'].map<Widget>((doc) => Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    const Icon(Icons.description, size: 16),
                    const SizedBox(width: 5),
                    Text(doc),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        // This would open the document in a real app
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Viewing document: $doc')),
                        );
                      },
                      child: const Text('View', style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              )).toList(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Verification'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Filter Users',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildFilterChip('All'),
                        _buildFilterChip('Farmer'),
                        _buildFilterChip('Buyer'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Text(user['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('${user['userType']} • ${user['address']}'),
                        const SizedBox(height: 4),
                        Text('Registered: ${user['registrationDate']}'),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: user['status'] == 'Pending'
                                ? Colors.orange.shade100
                                : user['status'] == 'Verified'
                                    ? Colors.green.shade100
                                    : Colors.red.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            user['status'],
                            style: TextStyle(
                              color: user['status'] == 'Pending'
                                  ? Colors.orange.shade800
                                  : user['status'] == 'Verified'
                                      ? Colors.green.shade800
                                      : Colors.red.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility, color: Colors.blue),
                          onPressed: () => _viewUserDetails(user),
                        ),
                        if (user['status'] == 'Pending') ...[
                          IconButton(
                            icon: const Icon(Icons.check_circle, color: Colors.green),
                            onPressed: () => _verifyUser(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            onPressed: () => _rejectUser(index),
                          ),
                        ],
                      ],
                    ),
                    onTap: () => _viewUserDetails(user),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = selectedFilter == label;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        _filterUsers(label);
      },
      backgroundColor: Colors.grey.shade200,
      selectedColor: Colors.teal.shade100,
      checkmarkColor: Colors.teal,
      labelStyle: TextStyle(
        color: isSelected ? Colors.teal.shade700 : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
