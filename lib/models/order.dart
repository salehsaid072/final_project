import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  static const String collectionName = 'orders';
  static const String statusPending = 'pending';
  static const String statusConfirmed = 'confirmed';
  static const String statusCancelled = 'cancelled';
  static const String statusCompleted = 'completed';
  final String id;
  final String buyerName;
  final String productName;
  final int quantity;
  final double price;
  final String phoneNumber;
  final String address;
  final String notes;
  final String status;
  final DateTime timestamp;
  final String sellerId;
  final String paymentStatus;

  Order({
    required this.id,
    required this.buyerName,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.phoneNumber,
    required this.address,
    required this.notes,
    required this.status,
    required this.timestamp,
    required this.sellerId,
    required this.paymentStatus,
  });

  // Convert to map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'buyerName': buyerName,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'phoneNumber': phoneNumber,
      'address': address,
      'notes': notes,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
      'sellerId': sellerId,
      'paymentStatus': paymentStatus,
    };
  }

  // Convert Firestore document to Order object
  factory Order.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Order(
      id: doc.id,
      buyerName: data['buyerName'] ?? '',
      productName: data['productName'] ?? '',
      quantity: (data['quantity'] ?? 0).toInt(),
      price: (data['price'] ?? 0.0).toDouble(),
      phoneNumber: data['phoneNumber'] ?? '',
      address: data['address'] ?? '',
      notes: data['notes'] ?? '',
      status: data['status'] ?? statusPending,
      timestamp: DateTime.parse(data['timestamp'] ?? DateTime.now().toIso8601String()),
      sellerId: data['sellerId'] ?? '',
      paymentStatus: data['paymentStatus'] ?? 'pending',
    );
  }

  // Get total price of the order
  double get totalPrice => price * quantity;

  // Check if order can be confirmed
  bool get canConfirm => status == statusPending;
  
  // Check if order can be cancelled
  bool get canCancel => status == statusPending || status == statusConfirmed;
  
  // Check if order is completed
  bool get isCompleted => status == statusCompleted;
}
