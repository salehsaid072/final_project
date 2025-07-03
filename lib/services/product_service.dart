import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import '../models/product.dart' as model;

// Hide the Transaction class from cloud_firestore
export 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;

class ProductService {
  final firestore.FirebaseFirestore _firestore = firestore.FirebaseFirestore.instance;

  Future<void> addProduct(model.Product product) async {
    try {
      await _firestore.collection('products').add(product.toMap());
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  Future<void> updateProduct(String productId, model.Product product) async {
    try {
      await _firestore.collection('products').doc(productId).update(product.toMap());
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

  Future<List<model.Product>> getAllProducts() async {
    try {
      final snapshot = await _firestore.collection('products').get();
      return snapshot.docs.map((doc) => model.Product.fromFirestore(doc, null)).toList();
    } catch (e) {
      throw Exception('Failed to get all products: $e');
    }
  }

  Future<List<model.Product>> getProductsByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .where('category', isEqualTo: category)
          .get();
      return snapshot.docs.map((doc) => model.Product.fromFirestore(doc, null)).toList();
    } catch (e) {
      throw Exception('Failed to get products by category: $e');
    }
  }

  Future<model.Product?> getProductById(String productId) async {
    try {
      final doc = await _firestore.collection('products').doc(productId).get();
      if (doc.exists) {
        return model.Product.fromFirestore(doc, null);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get product by ID: $e');
    }
  }

  Future<void> updateProductQuantity(String productId, int newQuantity) async {
    try {
      await _firestore.collection('products').doc(productId).update({
        'quantity': newQuantity
      });
    } catch (e) {
      throw Exception('Failed to update product quantity: $e');
    }
  }
}
