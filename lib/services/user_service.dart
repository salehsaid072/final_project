import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user by ID
  Future<UserModel> getUser(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) {
        throw Exception('User not found');
      }
      return UserModel.fromMap(doc.id, doc.data()!);
    } catch (e) {
      rethrow;
    }
  }

  // Search users by name or email
  Stream<List<UserModel>> searchUsers(String query) {
    if (query.isEmpty) {
      return const Stream.empty();
    }

    final searchLower = query.toLowerCase();
    
    return _firestore
        .collection('users')
        .where(
          'searchTerms',
          arrayContains: searchLower,
        )
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromMap(doc.id, doc.data()))
            .toList());
  }

  // Update user's profile picture
  Future<void> updateProfilePicture({
    required String userId,
    required String imageUrl,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'profilePicture': imageUrl,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Check if email exists
  Future<bool> checkEmailExists(String email) async {
    try {
      final result = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      return result.docs.isNotEmpty;
    } catch (e) {
      rethrow;
    }
  }

  // // Get user by role
  // Stream<List<UserModel>> getUsersByRole(String role) {
  //   return _firestore
  //       .collection('users')
  //       .where('role', isEqualTo: role)
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs
  //           .map((doc) => UserModel.fromMap(doc.id, doc.data()))
  //           .toList());
  // }

  // Update user's FCM token for notifications
  Future<void> updateFcmToken({
    required String userId,
    required String? token,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': token,
      });
    } catch (e) {
      rethrow;
    }
  }
}
