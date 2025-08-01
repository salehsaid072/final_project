import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projectfrontend/services/auth_service.dart';
import 'package:projectfrontend/models/user.dart' as user_model;
import 'package:projectfrontend/profile%20screen/widgets/edit_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  user_model.UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // We'll load data in didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Listen to auth state changes
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.addListener(_onAuthStateChanged);
    
    // Load user data after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadUserData();
      }
    });
  }
  
  @override
  void dispose() {
    // Remove the listener when the widget is disposed
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.removeListener(_onAuthStateChanged);
    super.dispose();
  }
  
  void _onAuthStateChanged() {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
      _loadUserData();
    }
  }

  // Show error message safely
  void _showErrorMessage(String message) {
    if (!mounted) return;
    
    // Ensure we're not in the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  // Show success message
  void _showSuccessMessage(String message) {
    if (!mounted) return;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  // Load user data
  Future<void> _loadUserData() async {
    if (!mounted) return;

    try {
      print('1. Starting to load user data...');
      
      // Get AuthService instance
      final authService = Provider.of<AuthService>(context, listen: false);
      final firebaseUser = authService.currentUser;
      print('2. Firebase User: ${firebaseUser?.uid ?? 'null'}');

      if (firebaseUser == null) {
        print('3. No firebase user found');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          _showErrorMessage('No authenticated user found. Please log in.');
        }
        return;
      }

      // Get the user document from Firestore
      print('4. Fetching user document from Firestore...');
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      print('5. User document exists: ${userDoc.exists}');
      
      if (userDoc.exists) {
        final userData = userDoc.data();
        print('6. User data from Firestore: $userData');
        
        if (userData != null) {
          if (mounted) {
            setState(() {
              _user = user_model.UserModel(
                id: userDoc.id,
                fullName: userData['fullName'] ?? 'No Name',
                email: userData['email'] ?? 'No Email',
                address: userData['address'] ?? 'Not provided',
                userType: (userData['userType'] ?? 'buyer').toString().toLowerCase() == 'buyer' 
                    ? 'Buyer' 
                    : 'Farmer',
              );
              _isLoading = false;
              print('7. User model created: ${_user?.toMap()}');
            });
          }
        } else {
          print('8. User data is null in Firestore document');
          // Instead of throwing, create a default user
          if (mounted) {
            setState(() {
              _user = user_model.UserModel(
                id: firebaseUser.uid,
                fullName: firebaseUser.displayName ?? 'New User',
                email: firebaseUser.email ?? 'No email',
                address: 'Not provided',
                userType: 'Buyer',
              );
              _isLoading = false;
            });
          }
        }
      } else {
        // Create a new user profile if it doesn't exist
        final newUser = user_model.UserModel(
          id: firebaseUser.uid,
          fullName: firebaseUser.displayName ?? 'New User',
          address: 'Not provided',
          email: firebaseUser.email ?? 'No email',
          userType: 'Buyer',
        );
        
        await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .set({
              'fullName': newUser.fullName,
              'email': newUser.email,
              'address': newUser.address,
              'userType': newUser.userType.toLowerCase(),
              'createdAt': FieldValue.serverTimestamp(),
            });
            
        if (mounted) {
          setState(() {
            _user = newUser;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error loading profile. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      debugPrint('Error loading user data: $e');
    }
  }

  Future<void> _signOut() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout != true) return;

    try {
      setState(() => _isLoading = true);
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing out: ${e.message}')),
        );
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _navigateToEditProfile() async {
    if (_user == null) {
      _showErrorMessage('User data not available. Please try again.');
      return;
    }
    
    try {
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => EditProfileScreen(user: _user!),
        ),
      );

      if (result == true && mounted) {
        // Show a loading indicator while refreshing data
        if (mounted) {
          setState(() {
            _isLoading = true;
          });
        }
        await _loadUserData();
        _showSuccessMessage('Profile updated successfully!');
      }
    } catch (e) {
      _showErrorMessage('Failed to open edit profile: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(
          child: Text('Failed to load profile data. Please try again later.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEditProfile(),
            tooltip: 'Edit Profile',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.teal.shade100,
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _user?.fullName ?? 'No Name',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _user?.email ?? 'No Email',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_user?.userType != null)
                      Chip(
                        label: Text(
                          _user!.userType,
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.teal,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Account Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoRow('Address', _user?.address ?? 'Not provided'),
                    const Divider(),
                    _buildInfoRow('User Type', _user?.userType ?? 'Not specified'),
                  ],
                ),
              ),
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
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'Not provided',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
