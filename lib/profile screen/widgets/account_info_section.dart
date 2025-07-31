import 'package:flutter/material.dart';
import 'package:projectfrontend/models/user.dart' as user_model;

class AccountInfoSection extends StatelessWidget {
  final user_model.UserModel user;

  const AccountInfoSection({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              'Full Name',
              user.fullName,
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              'Email Address',
              user.email,
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              'User Type',
              user.userType,
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              'Address',
              user.address.isNotEmpty ? user.address : 'Not provided',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
