import 'package:flutter/material.dart';

class DeleteAccountDialog extends StatelessWidget {
  final VoidCallback? onDelete;

  const DeleteAccountDialog({super.key, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Account'),
      content: const Text(
        'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
            onDelete?.call();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Account has been deleted successfully'),
              ),
            );
          },
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  static Future<bool?> show(
    BuildContext context, {
    VoidCallback? onDelete,
  }) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => DeleteAccountDialog(onDelete: onDelete),
    );
  }
}
