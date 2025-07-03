import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import 'widgets/profile_header.dart';
import 'widgets/resume_section.dart';
import 'widgets/skills_section.dart';
import 'widgets/qualification_section.dart';
import 'widgets/logout_dialog.dart';
import 'widgets/delete account/delete_account_button.dart';
import 'widgets/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load user data
  Future<void> _loadUserData() async {
    if (!mounted) return;

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final firebaseUser = authService.currentUser;

      if (firebaseUser == null) {
        if (mounted) {
          setState(() {
            _currentUser = null;
            _isLoading = false;
          });
        }
        return;
      }

      // Get the user document from Firestore
      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(firebaseUser.uid)
              .get();

      if (userDoc.exists && mounted) {
        setState(() {
          _currentUser = UserModel.fromMap(firebaseUser.uid, userDoc.data()!);
          _isLoading = false;
        });
      } else {
        // Create a new user document if it doesn't exist
        if (mounted) {
          setState(() {
            _currentUser = UserModel(
              id: firebaseUser.uid,
              userType: 'farmer', // Default role
              fullName: firebaseUser.displayName?.split(' ').first ?? '',
              email: firebaseUser.email ?? '',
              address: '',
            );
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load profile data')),
        );
      }
    }
  }

  Future<void> _showLogoutDialog() async {
    await LogoutDialog.show(context);
  }

  Future<void> _showDeleteAccountDialog() async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.deleteAccount();

      if (mounted) {
        // Navigate to login screen after successful deletion
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete account: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _showLogoutDialog,
            tooltip: 'Log Out',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: _loadUserData,
      child:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _currentUser == null
              ? const Center(child: Text('No user data available'))
              : _buildProfileContent(),
    );
  }

  Widget _buildProfileContent() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeader(
            name: _currentUser?.fullName ?? '',
            email: _currentUser?.email ?? 'No email',
            location: _currentUser?.address ?? 'Location not set',
            onEditPressed: () async {
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(user: _currentUser!),
                ),
              );

              // If the profile was updated, refresh the user data
              if (updated == true) {
                _loadUserData(); // Make sure this method exists in your _ProfileScreenState
              }
            },
          ),
          const SizedBox(height: 30),
          const ResumeSection(),
          const SizedBox(height: 30),
          const SkillsSection(),
          const SizedBox(height: 30),
          const QualificationsSection(),
          const SizedBox(height: 30),
          // Delete account button
          DeleteAccountButton(onPressed: _showDeleteAccountDialog),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
