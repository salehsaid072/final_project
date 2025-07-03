import 'package:flutter/material.dart';
import 'notification_service.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationService _notificationService = NotificationService();
  
  // Sample notifications - in a real app, these would come from a database or API
  final List<Map<String, dynamic>> notifications = [
    {
      'id': '1',
      'title': 'Order Confirmation',
      'message': 'Your order #12345 has been confirmed by the farmer.',
      'time': '2 hours ago',
      'isRead': false,
      'type': 'order',
    },
    {
      'id': '2',
      'title': 'Payment Successful',
      'message': 'Your payment of 1500 TZS for order #12345 was successful.',
      'time': '2 hours ago',
      'isRead': false,
      'type': 'payment',
    },
    {
      'id': '3',
      'title': 'New Product Available',
      'message': 'Fresh tomatoes are now available from your favorite farmer.',
      'time': '1 day ago',
      'isRead': true,
      'type': 'product',
    },
    {
      'id': '4',
      'title': 'Delivery Update',
      'message': 'Your order #12345 is out for delivery.',
      'time': '3 days ago',
      'isRead': true,
      'type': 'delivery',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Reset notification count when viewing this page
    _notificationService.notificationCount = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Notifications'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: () {
              _showClearConfirmDialog();
            },
          ),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : _buildNotificationsList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'We\'ll notify you when something important happens',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationItem(notification);
      },
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    IconData iconData;
    Color iconColor;

    // Set icon based on notification type
    switch (notification['type']) {
      case 'order':
        iconData = Icons.shopping_cart;
        iconColor = Colors.blue;
        break;
      case 'payment':
        iconData = Icons.payment;
        iconColor = Colors.green;
        break;
      case 'product':
        iconData = Icons.store;
        iconColor = Colors.orange;
        break;
      case 'delivery':
        iconData = Icons.local_shipping;
        iconColor = Colors.purple;
        break;
      default:
        iconData = Icons.notifications;
        iconColor = Colors.teal;
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: notification['isRead'] ? 1 : 3,
      color: notification['isRead'] ? Colors.white : Colors.teal.shade50,
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.2),
          child: Icon(iconData, color: iconColor),
        ),
        title: Text(
          notification['title'],
          style: TextStyle(
            fontWeight: notification['isRead'] ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(notification['message']),
            SizedBox(height: 8),
            Text(
              notification['time'],
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        onTap: () {
          setState(() {
            notification['isRead'] = true;
          });
          // Show notification details
          _showNotificationDetails(notification);
        },
        trailing: !notification['isRead']
            ? Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.teal,
                  shape: BoxShape.circle,
                ),
              )
            : null,
      ),
    );
  }

  void _showNotificationDetails(Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification['title']),
        content: Text(notification['message']),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showClearConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear All Notifications'),
        content: Text('Are you sure you want to clear all notifications?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                notifications.clear();
              });
              Navigator.pop(context);
            },
            child: Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
