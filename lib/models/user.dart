

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

  // Create UserModel from Firestore document
  factory UserModel.fromMap(String id, Map<String, dynamic> map) {
    return UserModel(
      id: id,
      fullName: map['fullName'] as String,
      address: map['address'] as String,
      email: map['email'] as String,
      userType: map['userType'] as String,
      isVerified: map['isVerified'] as bool? ?? false,
    );
  }

  // Create an empty UserModel
  factory UserModel.empty() {
    return UserModel(
      id: '',
      fullName: '',
      address: '',
      email: '',
      userType: '',
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
