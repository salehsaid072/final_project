// product_service.dart

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../models/product.dart' as model;

class ProductService {
  final firestore.FirebaseFirestore _firestore = firestore.FirebaseFirestore.instance;

  // Method mpya ya kurudisha stream ya bidhaa zote au kwa kategoria
  Stream<List<model.Product>> getProductsStream({
    String? category,
    String sortBy = 'Newest First',
    String? farmerId,
  }) {
    firestore.Query query = _firestore.collection('products');
    
    if (farmerId != null) {
      query = query.where('farmerId', isEqualTo: farmerId);
    }
    
    if (category != null && category != 'All') {
      query = query.where('category', isEqualTo: category);
    }

    if (sortBy == 'Price: Low to High') {
      query = query.orderBy('price', descending: false);
    } else if (sortBy == 'Price: High to Low') {
      query = query.orderBy('price', descending: true);
    } else if (sortBy == 'Newest First') {
      query = query.orderBy('createdAt', descending: true);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => model.Product.fromFirestore(doc as dynamic, null)).toList();
    });
  }

  Future<void> addProduct(model.Product product, String farmerId) async {
    try {
      final newProductData = product.toMap();
      newProductData['farmerId'] = farmerId;
      newProductData['createdAt'] = firestore.FieldValue.serverTimestamp();
      newProductData['updatedAt'] = firestore.FieldValue.serverTimestamp();
      await _firestore.collection('products').add(newProductData);
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  Future<void> updateProduct(String productId, model.Product product) async {
    try {
      final updateData = product.toMap();
      updateData['updatedAt'] = firestore.FieldValue.serverTimestamp();
      await _firestore.collection('products').doc(productId).update(updateData);
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }
}