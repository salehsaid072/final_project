import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductDetailsPage extends StatelessWidget {
  final String name;
  final String price;
  final String quantity;
  final String description;
  final String imagePath;

  const ProductDetailsPage({
    Key? key,
    this.name = 'Default Product', // Default value ikiwa data haijapitia
    this.price = '0 TZS',
    this.quantity = '1 Unit',
    this.description = 'No description available',
    this.imagePath = 'assets/images/default.png', // Picha ya default ikiwa haijapitia
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Safely get product data with null checks
  final product = (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ?? {
    'name': name,
    'price': price, // This is the class field with default value
    'quantity': quantity,
    'description': description,
    'imagePath': imagePath,
    'rating': 4.0,
    'farmer': 'Local Farmer',
    'location': 'N/A',
  };
  
  // Parse the price from product data
  final productPrice = double.tryParse(product['price']?.toString() ?? '0') ?? 0;
  final formattedPrice = NumberFormat.currency(symbol: 'TZS ', decimalDigits: 0).format(productPrice);
    
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _displayImage(product['imagePath']),
            ),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                width: 48,
                height: 48,
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Title and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product['name'] ?? 'Product Name',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[900],
                          ),
                        ),
                      ),
                      Text(
                        formattedPrice,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[700],
                        ),
                      ),
                    ],
                  ),
                  
                  // Rating and Availability
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Row(
                        children: List.generate(5, (index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 20,
                        )),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${product['rating'] ?? '4.5'}/5.0',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'In Stock (${product['quantity'] ?? 'N/A'})',
                          style: TextStyle(
                            color: Colors.green[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Description
                  const SizedBox(height: 24),
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product['description'] ?? 'No description available',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  
                  // Seller Info
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.teal[100],
                        child: Icon(Icons.store, color: Colors.teal[700]),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sold by',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            product['farmer'] ?? 'Local Farmer',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Icon(Icons.location_on, color: Colors.teal[700]),
                      const SizedBox(width: 4),
                      Text(
                        product['location'] ?? 'N/A',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  
                  // Spacer to push the bottom button up
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // Fixed Buy Now Button
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Quantity Selector
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 20),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    Container(
                      width: 40,
                      alignment: Alignment.center,
                      child: const Text('1', style: TextStyle(fontSize: 16)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 20),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              
              // Buy Now Button
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/checkout',
                        arguments: {
                          'name': product['name'],
                          'price': productPrice.toString(),
                          'quantity': 1, // Default quantity
                          'description': product['description'],
                          'imagePath': product['imagePath'],
                          'farmer': product['farmer'],
                          'location': product['location'],
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[700],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Buy Now',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _displayImage(String? imagePath) {
    Widget imageWidget;
    
    try {
      if (imagePath == null || imagePath.isEmpty) {
        return _placeholderImage();
      }
      
      if (imagePath.startsWith('http') || imagePath.startsWith('https')) {
        imageWidget = Image.network(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _placeholderImage(),
        );
      } else if (imagePath.startsWith('assets/')) {
        imageWidget = Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _placeholderImage(),
        );
      } else {
        // For local file paths
        final file = File(imagePath);
        if (file.existsSync()) {
          imageWidget = Image.file(
            file,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _placeholderImage(),
          );
        } else {
          return _placeholderImage();
        }
      }
    
      return Container(
        height: 300,
        width: double.infinity,
        child: imageWidget,
      );
    } catch (e) {
      return _placeholderImage();
    }
  }

  Widget _placeholderImage() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported, size: 50, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text('No Image Available', style: TextStyle(color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }
}