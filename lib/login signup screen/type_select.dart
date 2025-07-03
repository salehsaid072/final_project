import 'package:flutter/material.dart';

class RoleSelection extends StatelessWidget {
  final String selectedRole;
  final ValueChanged<String> onRoleChanged;

  const RoleSelection({
    super.key,
    required this.selectedRole,
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'User Type',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
          RadioListTile<String>(
            title: const Text(
              'Farmer',
              style: TextStyle(color: Colors.white),
            ),
            value: 'farmer',
            groupValue: selectedRole,
            onChanged: (value) => onRoleChanged(value!),
          ),
          RadioListTile<String>(
            title: const Text(
              'Buyer',
              style: TextStyle(color: Colors.white),
            ),
            value: 'buyer',
            groupValue: selectedRole,
            onChanged: (value) => onRoleChanged(value!),
          ),
        ],
      ),
    );
  }
}