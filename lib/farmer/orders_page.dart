import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order.dart' as model;
import '../services/order_service.dart';
import '../services/auth_service.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final OrderService _orderService = OrderService();
  final AuthService _authService = AuthService();
  List<model.Order> _orders = [];
  bool _isLoading = true;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    try {
      final user = _authService.currentUser;
      if (user != null) {
        _currentUserId = user.uid;
        _orders = await _orderService.getOrdersBySeller(_currentUserId!);
      } else {
        // If user is null, they might be signed out
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please sign in to view orders')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load orders: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadOrders,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? const Center(child: Text('No orders found'))
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Order ID')),
                        DataColumn(label: Text('Product')),
                        DataColumn(label: Text('Buyer')),
                        DataColumn(label: Text('Qty'), numeric: true),
                        DataColumn(label: Text('Total'), numeric: true),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Date')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: _orders.map((order) {
                        final dateFormat = DateFormat('dd MMM yyyy HH:mm');
                        final formattedDate = dateFormat.format(order.timestamp);
                        final total = order.price * order.quantity;

                        return DataRow(
                          cells: [
                            DataCell(Text(
                              '#${order.id.substring(0, 8)}',
                              style: const TextStyle(fontFamily: 'monospace'),
                            )),
                            DataCell(Text(order.productName)),
                            DataCell(Text(order.buyerName)),
                            DataCell(Text(order.quantity.toString())),
                            DataCell(Text('${total.toStringAsFixed(2)} TZS')),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(order.status),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  order.status.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(Text(formattedDate)),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (order.status == model.Order.statusPending)
                                    IconButton(
                                      icon: const Icon(Icons.check_circle, color: Colors.green, size: 24),
                                      onPressed: () => _updateOrderStatus(order.id, model.Order.statusConfirmed),
                                      tooltip: 'Confirm Order',
                                    ),
                                  if (order.status != model.Order.statusCancelled && 
                                      order.status != model.Order.statusCompleted)
                                    IconButton(
                                      icon: const Icon(Icons.cancel, color: Colors.red, size: 24),
                                      onPressed: () => _updateOrderStatus(order.id, model.Order.statusCancelled),
                                      tooltip: 'Cancel Order',
                                    ),
                                  if (order.status == model.Order.statusConfirmed)
                                    IconButton(
                                      icon: const Icon(Icons.done_all, color: Colors.blue, size: 24),
                                      onPressed: () => _updateOrderStatus(order.id, model.Order.statusCompleted),
                                      tooltip: 'Mark as Completed',
                                    ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
    );
  }

  Future<void> _updateOrderStatus(String orderId, String newStatus) async {
    try {
      setState(() => _isLoading = true);
      await _orderService.updateOrderStatus(orderId, newStatus);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order marked as ${newStatus.toLowerCase()}')),
        );
        await _loadOrders(); // Refresh the orders list
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update order status: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case model.Order.statusConfirmed:
        return Colors.green;
      case model.Order.statusCancelled:
        return Colors.red;
      case model.Order.statusCompleted:
        return Colors.blue;
      case model.Order.statusPending:
      default:
        return Colors.orange;
    }
  }
}