import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order.dart' as model;

/// Service class for handling order-related operations with Firestore
class OrderService {
  static const String _collectionName = 'orders';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Get the orders collection reference
  CollectionReference<Map<String, dynamic>> get _ordersCollection => 
      _firestore.collection(_collectionName).withConverter<Map<String, dynamic>>(
        fromFirestore: (snapshot, _) => snapshot.data()!,
        toFirestore: (data, _) => data,
      );
  
  // Get the raw orders collection (for methods that don't need conversion)
  CollectionReference<Map<String, dynamic>> get _rawOrdersCollection => 
      _firestore.collection(_collectionName);

  /// Creates a new order in Firestore
  /// Returns the ID of the created order
  Future<String> createOrder(model.Order order) async {
    try {
      final docRef = await _ordersCollection.add(order.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  /// Updates an existing order in Firestore
  Future<void> updateOrder(String orderId, model.Order order) async {
    try {
      await _ordersCollection.doc(orderId).update(order.toMap());
    } catch (e) {
      throw Exception('Failed to update order: $e');
    }
  }

  /// Deletes an order from Firestore
  Future<void> deleteOrder(String orderId) async {
    try {
      await _ordersCollection.doc(orderId).delete();
    } catch (e) {
      throw Exception('Failed to delete order: $e');
    }
  }

  /// Retrieves an order by its ID
  /// Returns null if no order is found
  Future<model.Order?> getOrderById(String orderId) async {
    try {
      final doc = await _ordersCollection.doc(orderId).get();
      if (doc.exists) {
        return model.Order.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get order by ID: $e');
    }
  }

  /// Gets all orders for a specific buyer
  Future<List<model.Order>> getOrdersByBuyer(String buyerId) async {
    try {
      final querySnapshot = await _rawOrdersCollection
          .where('buyerId', isEqualTo: buyerId)
          .orderBy('timestamp', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => model.Order.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get orders by buyer: $e');
    }
  }

  /// Gets all orders for a specific seller (farmer)
  Future<List<model.Order>> getOrdersBySeller(String sellerId) async {
    try {
      final querySnapshot = await _rawOrdersCollection
          .where('sellerId', isEqualTo: sellerId)
          .orderBy('timestamp', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => model.Order.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get orders by seller: $e');
    }
  }

  /// Updates the status of an order
  /// Also updates the 'updatedAt' timestamp
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _ordersCollection.doc(orderId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  /// Stream of orders for a specific seller in real-time
  Stream<List<model.Order>> streamOrdersBySeller(String sellerId) {
    return _rawOrdersCollection
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => model.Order.fromFirestore(doc))
            .toList());
  }
}
