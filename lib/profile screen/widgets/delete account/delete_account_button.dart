import 'package:flutter/material.dart';
import 'delete_account_dialog.dart';

class DeleteAccountButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const DeleteAccountButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () async {
            final shouldDelete = await DeleteAccountDialog.show(
              context,
              onDelete: null, // Don't call onPressed here
            );
            if (shouldDelete == true) {
              onPressed?.call();
            }
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.red.shade700,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            side: BorderSide(color: Colors.red.shade300, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delete_outline, size: 20),
              SizedBox(width: 8),
              Text('Delete Account'),
            ],
          ),
        ),
      ),
    );
  }
}
