import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../services/auth_service.dart';
import '../../../services/image_service.dart';

class ProfilePicture extends StatefulWidget {
  final String? imageUrl;
  final double radius;
  final VoidCallback? onUpdateComplete;
  final VoidCallback? onUpdateStart;

  const ProfilePicture({
    super.key,
    this.imageUrl,
    this.radius = 45.0,
    this.onUpdateComplete,
    this.onUpdateStart,
  });

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  bool _isLoading = false;

  Future<void> _updateProfilePicture() async {
    final imageService = ImageService();
    final authService = context.read<AuthService>();

    try {
      // On web, only show gallery option
      final source =
          kIsWeb
              ? ImageSource.gallery
              : await showModalBottomSheet<ImageSource>(
                context: context,
                builder:
                    (context) => SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.camera_alt),
                            title: const Text('Take Photo'),
                            onTap:
                                () =>
                                    Navigator.pop(context, ImageSource.camera),
                          ),
                          ListTile(
                            leading: const Icon(Icons.photo_library),
                            title: const Text('Choose from Gallery'),
                            onTap:
                                () =>
                                    Navigator.pop(context, ImageSource.gallery),
                          ),
                        ],
                      ),
                    ),
              );

      if (source == null) return;

      setState(() {
        _isLoading = true;
        widget.onUpdateStart?.call();
      });

      // Always use pickImageFromGallery for now
      // I can implement takePhoto() later if needed
      final image = await imageService.pickImageFromGallery();

      if (kIsWeb && image is Uint8List) {
        print('Picked image byte length: ${image.length}');
      }

      if (image == null) {
        setState(() => _isLoading = false);
        return;
      }

      // Upload and update profile picture
      await authService.updateProfilePicture(image);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated successfully')),
        );
        widget.onUpdateComplete?.call();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile picture: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: widget.radius,
          backgroundImage: _getProfileImage(),
          backgroundColor: Colors.grey.shade300,
          child: _isLoading ? const CircularProgressIndicator() : null,
        ),
        if (!_isLoading)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _updateProfilePicture,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
      ],
    );
  }

  ImageProvider? _getProfileImage() {
    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      return NetworkImage(widget.imageUrl!);
    }
    return const AssetImage('assets/images/profile1.jpg');
  }
}
