

class UserModel {
  final String id;
  final String fullName;
  final String address;
  final String email;
  final String userType;
  final bool isVerified;

  UserModel({
    required this.id,
    required this.fullName,
    required this.address,
    required this.email,
    required this.userType,
    this.isVerified = false,
  });

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'address': address,
      'email': email,
      'userType': userType,
      'isVerified': isVerified,
    };
  }

  // Create UserModel from Firestore document with null safety
  factory UserModel.fromMap(String id, Map<String, dynamic> map) {
    return UserModel(
      id: id,
      fullName: (map['fullName'] as String?) ?? 'No Name',
      address: (map['address'] as String?) ?? 'No Address',
      email: (map['email'] as String?) ?? 'no-email@example.com',
      userType: (map['userType'] as String?)?.toLowerCase() == 'admin' 
          ? 'Admin' 
          : (map['userType'] as String?)?.toLowerCase() == 'farmer'
              ? 'Farmer'
              : 'Buyer',
      isVerified: (map['isVerified'] as bool?) ?? false,
    );
  }

  // Create an empty UserModel with default values
  factory UserModel.empty() {
    return UserModel(
      id: 'new-user',
      fullName: 'New User',
      address: 'Not specified',
      email: 'user@example.com',
      userType: 'Buyer',
      isVerified: false,
    );
  }

  // Create a copy of UserModel with updated fields
  UserModel copyWith({
    String? id,
    String? fullName,
    String? address,
    String? email,
    String? userType,
    bool? isVerified,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
