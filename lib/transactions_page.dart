import 'package:flutter/material.dart';
import 'notification_service.dart';

class TransactionsPage extends StatefulWidget {
  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final NotificationService _notificationService = NotificationService();
  String selectedPeriod = 'All Time';
  
  // Sample transactions data - in a real app, this would come from a database
  final List<Map<String, dynamic>> allTransactions = [
    {
      'id': 'T001',
      'amount': '1500',
      'date': '15 May 2025',
      'time': '10:30 AM',
      'method': 'M-Pesa',
      'status': 'Completed',
      'buyer': 'John Doe',
      'product': 'Fresh Tomatoes',
      'quantity': '10 Kg',
      'type': 'Sale'
    },
    {
      'id': 'T002',
      'amount': '800',
      'date': '14 May 2025',
      'time': '2:15 PM',
      'method': 'Tigo Pesa',
      'status': 'Completed',
      'buyer': 'Mary Smith',
      'product': 'Red Onions',
      'quantity': '5 Kg',
      'type': 'Sale'
    },
    {
      'id': 'T003',
      'amount': '2000',
      'date': '12 May 2025',
      'time': '9:45 AM',
      'method': 'Bank Transfer',
      'status': 'Pending',
      'buyer': 'Robert Johnson',
      'product': 'Avocados',
      'quantity': '8 Kg',
      'type': 'Sale'
    },
    {
      'id': 'T004',
      'amount': '500',
      'date': '10 May 2025',
      'time': '11:20 AM',
      'method': 'Cash on Delivery',
      'status': 'Completed',
      'buyer': 'Sarah Williams',
      'product': 'Fresh Maize',
      'quantity': '3 Kg',
      'type': 'Sale'
    },
    {
      'id': 'T005',
      'amount': '300',
      'date': '08 May 2025',
      'time': '4:30 PM',
      'method': 'Airtel Money',
      'status': 'Failed',
      'buyer': 'Michael Brown',
      'product': 'Bananas',
      'quantity': '2 Kg',
      'type': 'Sale'
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _notificationService.init();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredTransactions {
    List<Map<String, dynamic>> result = List.from(allTransactions);
    
    // Filter by status based on tab
    if (_tabController.index == 1) {
      result = result.where((tx) => tx['status'] == 'Completed').toList();
    } else if (_tabController.index == 2) {
      result = result.where((tx) => tx['status'] == 'Pending').toList();
    }
    
    // Filter by time period
    if (selectedPeriod != 'All Time') {
      final now = DateTime.now();
      DateTime cutoffDate;
      
      if (selectedPeriod == 'Today') {
        cutoffDate = DateTime(now.year, now.month, now.day);
      } else if (selectedPeriod == 'This Week') {
        cutoffDate = DateTime(now.year, now.month, now.day - 7);
      } else if (selectedPeriod == 'This Month') {
        cutoffDate = DateTime(now.year, now.month, 1);
      } else {
        cutoffDate = DateTime(now.year, 1, 1);
      }
      
      // This is a simplified date comparison - in a real app, you'd parse the actual date
      // For this example, we'll just filter based on the date string
      if (selectedPeriod == 'Today') {
        result = result.where((tx) => tx['date'] == '15 May 2025').toList();
      } else if (selectedPeriod == 'This Week') {
        result = result.where((tx) => 
          tx['date'] == '15 May 2025' || 
          tx['date'] == '14 May 2025' || 
          tx['date'] == '12 May 2025'
        ).toList();
      } else if (selectedPeriod == 'This Month') {
        // All transactions are in May, so no filtering needed
      }
    }
    
    return result;
  }

  double get totalAmount {
    return filteredTransactions
        .where((tx) => tx['status'] == 'Completed')
        .fold(0, (sum, tx) => sum + double.parse(tx['amount']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Transactions'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: 'All'),
            Tab(text: 'Completed'),
            Tab(text: 'Pending'),
          ],
          onTap: (index) {
            setState(() {});
          },
        ),
      ),
      body: Column(
        children: [
          _buildSummaryCard(),
          _buildFilterBar(),
          Expanded(
            child: filteredTransactions.isEmpty
                ? _buildEmptyState()
                : _buildTransactionsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      margin: EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Revenue',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${totalAmount.toStringAsFixed(2)} TZS',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    selectedPeriod,
                    style: TextStyle(fontSize: 14, color: Colors.teal),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.teal.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.payments, color: Colors.teal, size: 32),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Text('Period: ', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 8),
          Expanded(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedPeriod,
              underline: Container(height: 1, color: Colors.teal),
              items: ['Today', 'This Week', 'This Month', 'This Year', 'All Time']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedPeriod = newValue;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No transactions found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Transactions will appear here when you make sales',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: filteredTransactions.length,
      itemBuilder: (context, index) {
        final transaction = filteredTransactions[index];
        return _buildTransactionCard(transaction);
      },
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    Color statusColor;
    IconData statusIcon;
    
    switch (transaction['status']) {
      case 'Completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'Pending':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      case 'Failed':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }
    
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          _showTransactionDetails(transaction);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transaction #${transaction['id']}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Chip(
                    label: Text(
                      transaction['status'],
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    backgroundColor: statusColor,
                    avatar: Icon(statusIcon, color: Colors.white, size: 16),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Amount', style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 4),
                        Text(
                          '${transaction['amount']} TZS',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date', style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 4),
                        Text(
                          '${transaction['date']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Payment Method', style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 4),
                        Text(
                          '${transaction['method']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Buyer', style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 4),
                        Text(
                          '${transaction['buyer']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (transaction['status'] == 'Pending')
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          _confirmTransaction(transaction);
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.teal),
                        ),
                        child: Text('Confirm Payment'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTransactionDetails(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Transaction Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Transaction ID', transaction['id']),
              _buildDetailRow('Amount', '${transaction['amount']} TZS'),
              _buildDetailRow('Date', transaction['date']),
              _buildDetailRow('Time', transaction['time']),
              _buildDetailRow('Status', transaction['status']),
              _buildDetailRow('Payment Method', transaction['method']),
              _buildDetailRow('Buyer', transaction['buyer']),
              _buildDetailRow('Product', transaction['product']),
              _buildDetailRow('Quantity', transaction['quantity']),
              _buildDetailRow('Transaction Type', transaction['type']),
            ],
          ),
        ),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text('$label:', style: TextStyle(color: Colors.grey))),
          Expanded(child: Text(value, style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  void _confirmTransaction(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Payment'),
        content: Text('Are you sure you want to confirm the payment for transaction #${transaction['id']}?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                transaction['status'] = 'Completed';
              });
              
              // Show notification
              _notificationService.showNotification(
                'Payment Confirmed',
                'You have confirmed payment for transaction #${transaction['id']}.',
              );
              
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }
}