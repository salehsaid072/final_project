import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String id;
  final String buyerName;
  final String productName;
  final int quantity;
  final double price;
  final String phoneNumber;
  final String address;
  final String status;

  Order({
    required this.id,
    required this.buyerName,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.phoneNumber,
    required this.address,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'buyerName': buyerName,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'phoneNumber': phoneNumber,
      'address': address,
      'status': status,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] ?? '',
      buyerName: map['buyerName'] ?? '',
      productName: map['productName'] ?? '',
      quantity: map['quantity'] ?? 0,
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      phoneNumber: map['phoneNumber'] ?? '',
      address: map['address'] ?? '',
      status: map['status'] ?? 'pending',
    );
  }

  factory Order.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Order(
      id: snapshot.id,
      buyerName: data?['buyerName'] ?? '',
      productName: data?['productName'] ?? '',
      quantity: data?['quantity'] ?? 0,
      price: (data?['price'] as num?)?.toDouble() ?? 0.0,
      phoneNumber: data?['phoneNumber'] ?? '',
      address: data?['address'] ?? '',
      status: data?['status'] ?? 'pending',
    );
  }

  Order copyWith({
    String? id,
    String? buyerName,
    String? productName,
    int? quantity,
    double? price,
    String? phoneNumber,
    String? address,
    String? status,
  }) {
    return Order(
      id: id ?? this.id,
      buyerName: buyerName ?? this.buyerName,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      status: status ?? this.status,
    );
  }
}
