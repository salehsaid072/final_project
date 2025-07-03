import 'package:flutter/material.dart';
import 'profile_picture.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String location;
  final String? profileImageUrl;
  final VoidCallback? onEditPressed;
  final VoidCallback? onProfilePictureUpdate;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    required this.location,
    this.profileImageUrl,
    this.onEditPressed,
    this.onProfilePictureUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Replace the GestureDetector and Stack with ProfilePicture
          ProfilePicture(
            imageUrl: profileImageUrl,
            onUpdateComplete: onProfilePictureUpdate,
          ),
          const SizedBox(width: 20),

          // Name and Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                _buildInfoRow(Icons.email, email),
                const SizedBox(height: 2),
                _buildInfoRow(Icons.location_on, location),
                const SizedBox(height: 8),
                if (onEditPressed != null)
                  TextButton(
                    onPressed: onEditPressed,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
