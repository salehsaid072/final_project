

class UserModel {
  final String id;
  final String fullName;
  final String address;
  final String email;
  final String userType;

  UserModel({
    required this.id,
    required this.fullName,
    required this.address,
    required this.email,
    required this.userType,
  });

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'address': address,
      'email': email,
      'userType': userType,
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
    );
  }

  // Create a copy of UserModel with updated fields
  UserModel copyWith({
    String? id,
    String? fullName,
    String? address,
    String? email,
    String? userType,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      email: email ?? this.email,
      userType: userType ?? this.userType,
    );
  }
}
