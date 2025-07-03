import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  final String id;
  final String paymentMethod;
  final double amountPaid;
  final DateTime transactionDate;
  final String paymentStatus;

  Transaction({
    required this.id,
    required this.paymentMethod,
    required this.amountPaid,
    required this.transactionDate,
    required this.paymentStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'paymentMethod': paymentMethod,
      'amountPaid': amountPaid,
      'transactionDate': transactionDate,
      'paymentStatus': paymentStatus,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] ?? '',
      paymentMethod: map['paymentMethod'] ?? '',
      amountPaid: (map['amountPaid'] as num?)?.toDouble() ?? 0.0,
      transactionDate: (map['transactionDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      paymentStatus: map['paymentStatus'] ?? 'pending',
    );
  }

  factory Transaction.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Transaction(
      id: snapshot.id,
      paymentMethod: data?['paymentMethod'] ?? '',
      amountPaid: (data?['amountPaid'] as num?)?.toDouble() ?? 0.0,
      transactionDate: (data?['transactionDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      paymentStatus: data?['paymentStatus'] ?? 'pending',
    );
  }

  Transaction copyWith({
    String? id,
    String? paymentMethod,
    double? amountPaid,
    DateTime? transactionDate,
    String? paymentStatus,
  }) {
    return Transaction(
      id: id ?? this.id,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      amountPaid: amountPaid ?? this.amountPaid,
      transactionDate: transactionDate ?? this.transactionDate,
      paymentStatus: paymentStatus ?? this.paymentStatus,
    );
  }
}
