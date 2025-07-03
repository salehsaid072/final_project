import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    required String address,
    required String userType,
    String? profilePicture,
  }) async {
    try {
      // Create user in Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user profile in Firestore
      final user = UserModel(
        id: userCredential.user!.uid,
        fullName: fullName,
        address: address,
        userType: userType,
        email: email,
      );

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(user.toMap());

      // Send email verification
      await userCredential.user?.sendEmailVerification();

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthException(e));
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with email and password
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userDoc =
          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .get();

      if (!userDoc.exists) {
        throw Exception('User not found in database');
      }

      return UserModel.fromMap(userDoc.id, userDoc.data()!);
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthException(e));
    } catch (e) {
      rethrow;
    }
  }

  // Get current user profile
  Future<UserModel> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user signed in');

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) throw Exception('User not found in database');

      return UserModel.fromMap(userDoc.id, userDoc.data()!);
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthException(e));
    }
  }
  // In auth_service.dart, add these methods to your AuthService class

  // Add this method to update email
  Future<void> updateEmail(String newEmail, String currentPassword) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user signed in');
      if (user.email == newEmail) return; // No change needed

      // Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Update email
      await user.verifyBeforeUpdateEmail(newEmail);

      // Update email in Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'email': newEmail,
      });
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthException(e));
    }
  }

  // Add this method to update password
  Future<void> updatePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user signed in');

      // Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthException(e));
    }
  }

  Future<void> updateProfile({
    String? fullName,
    String? address,
    String? userType,
    String? profilePicture,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user signed in');

      final updates = <String, dynamic>{};
      if (fullName != null) updates['fullName'] = fullName;
      if (address != null) updates['address'] = address;
      if (userType != null) updates['userType'] = userType;
      if (profilePicture != null) updates['profilePicture'] = profilePicture;

      await _firestore.collection('users').doc(user.uid).update(updates);
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthException(e));
    }
  }

  // Update user's profile picture
  Future<UserModel?> updateProfilePicture(dynamic imageFile) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      // Delete old profile picture if exists
      

      // Upload new profile picture
     
      // Update user document in Firestore
     

      // Return updated user
      return await _getUserData(user.uid);
    } catch (e) {
      print('Error updating profile picture: $e');
      rethrow;
    }
  }

  // Helper method to get user data
  Future<UserModel?> _getUserData(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.exists ? UserModel.fromMap(userId, doc.data()!) : null;
  }

  // Send email verification
  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user is signed in');
      if (user.emailVerified) return;
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthException(e));
    }
  }

  // Check if email is verified
  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthException(e));
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user signed in');

      // Delete user data from Firestore
      await _firestore.collection('users').doc(user.uid).delete();

      // Delete auth account
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthException(e));
    }
  }

  // Helper method to handle Firebase auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    print('Auth Error - code: ${e.code}, message: ${e.message}');
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'You have entered wrong email or password';
      case 'email-already-in-use':
        return 'Email already in use';
      case 'weak-password':
        return 'Password is too weak (minimum 6 characters)';
      case 'invalid-email':
        return 'Please enter a valid email address';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'operation-not-allowed':
        return 'This operation is not allowed';
      case 'network-request-failed':
        return 'Network error. Please check your connection and try again';
      default:
        print('Unhandled auth error: $e');
        return 'An error occurred. Please try again';
    }
  }
}
