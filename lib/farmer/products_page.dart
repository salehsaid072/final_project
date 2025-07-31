import 'package:flutter/material.dart';

class ProductsPage extends StatelessWidget {
  final List<Map<String, String>> products = [
    {'id': '001', 'name': 'Tomatoes', 'category': 'Vegetables', 'price': '10', 'quantity': '100', 'image': 'assets/images/tomatoes.jpg'},
    {'id': '002', 'name': 'Cabbages', 'category': 'Vegetables', 'price': '15', 'quantity': '50', 'image': 'assets/images/cabbages.jpg'},
  ];

  ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Products')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/post_product');
              },
              child: const Text('Add Product'),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  border: TableBorder.all(color: Colors.teal, width: 1), // Border ya kisasa
                  headingRowColor: WidgetStateProperty.all(Colors.teal.shade100), // Rangi ya vichwa vya table
                  columns: [
                    const DataColumn(label: Text('Image', style: TextStyle(fontWeight: FontWeight.bold))),
                    const DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                    const DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                    const DataColumn(label: Text('Category', style: TextStyle(fontWeight: FontWeight.bold))),
                    const DataColumn(label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
                    const DataColumn(label: Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold))),
                    const DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: products.map((product) {
                    return DataRow(cells: [
                      DataCell(Image.asset(product['image']!, width: 50, height: 50)), // Sehemu ya picha
                      DataCell(Text(product['id']!)),
                      DataCell(Text(product['name']!)),
                      DataCell(Text(product['category']!)),
                      DataCell(Text('\$${product['price']}')),
                      DataCell(Text(product['quantity']!)),
                      DataCell(IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () {})),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}