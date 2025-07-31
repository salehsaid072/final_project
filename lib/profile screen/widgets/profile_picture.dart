import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:async';

class ProfilePicture extends StatefulWidget {
  final String? imageUrl;
  final double radius;
  final Function(String)? onImageUpdated;
  final String userId;

  const ProfilePicture({
    super.key,
    required this.userId,
    this.imageUrl,
    this.radius = 45.0,
    this.onImageUpdated,
  });

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  bool _isLoading = false;

  Future<void> _updateProfilePicture() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) return;

      // File size validation (5MB limit)
      if (!kIsWeb) {
        final file = File(image.path);
        final sizeInMB = await file.length() / (1024 * 1024);
        if (sizeInMB > 5) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Image size should be less than 5MB'),
                backgroundColor: Colors.orange,
              ),
            );
          }
          return;
        }
      }

      setState(() => _isLoading = true);

      // Generate a unique filename
      final String fileExtension = path.extension(image.path).toLowerCase();
      final String fileName = 'profile_${widget.userId}_${DateTime.now().millisecondsSinceEpoch}$fileExtension';
      
      // Reference to the file in Firebase Storage
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child(fileName);

      // Prepare the upload
      final SettableMetadata metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'uploadedBy': widget.userId,
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      );

      // Start the upload
      final UploadTask uploadTask;
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        uploadTask = storageRef.putData(bytes, metadata);
      } else {
        uploadTask = storageRef.putFile(File(image.path), metadata);
      }

      // Listen to upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        print('Upload progress: ${(progress * 100).toStringAsFixed(2)}%');
      });

      // Wait for the upload to complete with timeout
      final TaskSnapshot snapshot = await uploadTask
          .timeout(const Duration(seconds: 30))
          .onError((error, stackTrace) {
            throw Exception('Upload timed out. Please check your connection and try again.');
          });

      // Get the download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      // Notify parent widget about the update
      if (widget.onImageUpdated != null) {
        widget.onImageUpdated!(downloadUrl);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } on FirebaseException catch (e) {
      String errorMessage = 'An error occurred';
      
      switch (e.code) {
        case 'retry-limit-exceeded':
          errorMessage = 'Upload took too long. Please try again with a better connection.';
          break;
        case 'unauthorized':
          errorMessage = 'You are not authorized to upload files.';
          break;
        case 'canceled':
          errorMessage = 'Upload was canceled.';
          break;
        default:
          errorMessage = 'Upload failed: ${e.message}';
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } on TimeoutException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Upload timed out. Please check your connection and try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An unexpected error occurred: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
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
    if (widget.imageUrl?.isNotEmpty ?? false) {
      return NetworkImage(widget.imageUrl!);
    }
    return const AssetImage('assets/images/default_profile.png');
  }
}
