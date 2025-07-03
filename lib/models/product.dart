import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String productName;
  final String category;
  final double price;
  final int quantity;
  final String description;
  final List<String> images;

  Product({
    required this.id,
    required this.productName,
    required this.category,
    required this.price,
    required this.quantity,
    required this.description,
    required this.images,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productName': productName,
      'category': category,
      'price': price,
      'quantity': quantity,
      'description': description,
      'images': images,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      productName: map['productName'] ?? '',
      category: map['category'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 0,
      description: map['description'] ?? '',
      images: List<String>.from(map['images'] ?? []),
    );
  }

  factory Product.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Product(
      id: snapshot.id,
      productName: data?['productName'] ?? '',
      category: data?['category'] ?? '',
      price: (data?['price'] as num?)?.toDouble() ?? 0.0,
      quantity: (data?['quantity'] as num?)?.toInt() ?? 0,
      description: data?['description'] ?? '',
      images: List<String>.from(data?['images'] ?? []),
    );
  }

  Product copyWith({
    String? id,
    String? productName,
    String? category,
    double? price,
    int? quantity,
    String? description,
    List<String>? images,
  }) {
    return Product(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      category: category ?? this.category,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
      images: images ?? this.images,
    );
  }
}
