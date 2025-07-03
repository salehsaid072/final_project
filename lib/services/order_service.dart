import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import '../models/order.dart' as model;

// Hide the Order class from cloud_firestore
export 'package:cloud_firestore/cloud_firestore.dart' hide Order;

class OrderService {
  final firestore.FirebaseFirestore _firestore = firestore.FirebaseFirestore.instance;

  Future<String> createOrder(model.Order order) async {
    try {
      final docRef = await _firestore.collection('orders').add(order.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  Future<void> updateOrder(String orderId, model.Order order) async {
    try {
      await _firestore.collection('orders').doc(orderId).update(order.toMap());
    } catch (e) {
      throw Exception('Failed to update order: $e');
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).delete();
    } catch (e) {
      throw Exception('Failed to delete order: $e');
    }
  }

  Future<List<model.Order>> getOrdersByBuyer(String buyerName) async {
    try {
      final snapshot = await _firestore
          .collection('orders')
          .where('buyerName', isEqualTo: buyerName)
          .get();
      return snapshot.docs.map((doc) => model.Order.fromFirestore(doc, null)).toList();
    } catch (e) {
      throw Exception('Failed to get orders by buyer: $e');
    }
  }

  Future<List<model.Order>> getOrdersByStatus(String status) async {
    try {
      final snapshot = await _firestore
          .collection('orders')
          .where('status', isEqualTo: status)
          .get();
      return snapshot.docs.map((doc) => model.Order.fromFirestore(doc, null)).toList();
    } catch (e) {
      throw Exception('Failed to get orders by status: $e');
    }
  }

  Future<model.Order?> getOrderById(String orderId) async {
    try {
      final doc = await _firestore.collection('orders').doc(orderId).get();
      if (doc.exists) {
        return model.Order.fromFirestore(doc, null);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get order by ID: $e');
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': status
      });
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }
}

