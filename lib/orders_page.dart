import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  final List<Map<String, String>> orders = [
    {'orderNo': '12345', 'date': '05 May 2025', 'quantity': '10', 'price': '100', 'status': 'Pending'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Orders')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Ruhusu scroll ikiwa table ni kubwa
          child: DataTable(
            border: TableBorder.all(color: Colors.teal, width: 1), // Ongeza border kwenye table
            headingRowColor: WidgetStateProperty.all(Colors.teal.shade100), // Rangi ya vichwa vya table
            columns: [
              DataColumn(label: Text('Order No', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Order Date', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Confirm', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: orders.map((order) {
              return DataRow(
                cells: [
                  DataCell(Text(order['orderNo']!)),
                  DataCell(Text(order['date']!)),
                  DataCell(Text(order['quantity']!)),
                  DataCell(Text('\$${order['price']}')),
                  DataCell(Text(order['status']!)),
                  DataCell(
                    order['status'] == 'Pending'
                        ? IconButton(icon: Icon(Icons.check, color: Colors.green), onPressed: () {})
                        : Icon(Icons.check_circle, color: Colors.grey),
                  ),
                  DataCell(
                    order['status'] == 'Pending'
                        ? IconButton(icon: Icon(Icons.close, color: Colors.red), onPressed: () {})
                        : Icon(Icons.remove_circle, color: Colors.grey),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}