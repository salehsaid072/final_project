import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import '../models/transaction.dart' as model;

// Hide the Transaction class from cloud_firestore
export 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;

class TransactionService {
  final firestore.FirebaseFirestore _firestore = firestore.FirebaseFirestore.instance;

  Future<void> createTransaction(model.Transaction transaction) async {
    try {
      await _firestore.collection('transactions').add(transaction.toMap());
    } catch (e) {
      throw Exception('Failed to create transaction: $e');
    }
  }

  Future<void> updateTransaction(String transactionId, model.Transaction transaction) async {
    try {
      await _firestore.collection('transactions').doc(transactionId).update(transaction.toMap());
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _firestore.collection('transactions').doc(transactionId).delete();
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }

  Future<List<model.Transaction>> getTransactionsByStatus(String status) async {
    try {
      final snapshot = await _firestore
          .collection('transactions')
          .where('paymentStatus', isEqualTo: status)
          .get();
      return snapshot.docs.map((doc) => model.Transaction.fromFirestore(doc, null)).toList();
    } catch (e) {
      throw Exception('Failed to get transactions by status: $e');
    }
  }

  Future<List<model.Transaction>> getTransactionsByMethod(String method) async {
    try {
      final snapshot = await _firestore
          .collection('transactions')
          .where('paymentMethod', isEqualTo: method)
          .get();
      return snapshot.docs.map((doc) => model.Transaction.fromFirestore(doc, null)).toList();
    } catch (e) {
      throw Exception('Failed to get transactions by method: $e');
    }
  }

  Future<model.Transaction?> getTransactionById(String transactionId) async {
    try {
      final doc = await _firestore.collection('transactions').doc(transactionId).get();
      if (doc.exists) {
        return model.Transaction.fromFirestore(doc, null);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get transaction by ID: $e');
    }
  }

  Future<void> updateTransactionStatus(String transactionId, String status) async {
    try {
      await _firestore.collection('transactions').doc(transactionId).update({
        'paymentStatus': status
      });
    } catch (e) {
      throw Exception('Failed to update transaction status: $e');
    }
  }
}
