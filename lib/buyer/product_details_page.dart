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
    this.name = 'Default Product',
    this.price = '0 TZS',
    this.quantity = '1 Unit',
    this.description = 'No description available',
    this.imagePath = 'assets/images/default.png', // Make sure this path is correct in your assets
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the route arguments
    final routeArgs = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    
    // Use the passed arguments or fall back to widget properties
    final productName = routeArgs['name'] as String? ?? name;
    final productPrice = routeArgs['price'] as String? ?? price;
    final productQuantity = routeArgs['quantity'] as String? ?? quantity;
    final productDescription = routeArgs['description'] as String? ?? description;
    final productImagePath = routeArgs['imagePath'] as String? ?? imagePath;
    
    // Format the price
    final priceValue = double.tryParse(productPrice.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
    final formattedPrice = NumberFormat.currency(
      symbol: 'TZS ',
      decimalDigits: 0,
    ).format(priceValue);
    
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120), // Added bottom padding to prevent overflow
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with fixed aspect ratio
            AspectRatio(
              aspectRatio: 1, // Square image
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: _buildProductImage(productImagePath),
              ),
            ),
            
            // Product Details
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          productName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 16),
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
                  
                  // Rating and Stock
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildRatingStars(),
                      const SizedBox(width: 8),
                      Text(
                        '4.5/5.0',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'In Stock ($productQuantity)',
                          style: TextStyle(
                            color: Colors.green[800],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Description
                  const SizedBox(height: 24),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    productDescription,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                      height: 1.5,
                    ),
                  ),
                  
                  // Seller Info
                  const SizedBox(height: 32),
                  _buildSellerInfo(),
                  const SizedBox(height: 20), // Extra space at the bottom
                ],
              ),
            ),
          ],
        ),
      ),
      
      // Buy Now Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24), // Increased bottom padding
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
          child: ElevatedButton(
            onPressed: () {
              // Navigate to checkout with product details
              // Extract available quantity from the product quantity string (e.g., '10 units' -> 10)
              final availableQty = int.tryParse(productQuantity.split(' ')[0]) ?? 1;
              
              Navigator.pushNamed(
                context,
                '/checkout',
                arguments: {
                  'name': productName,
                  'price': priceValue, // Using the parsed numeric value
                  'quantity': 1, // Start with quantity 1
                  'availableQuantity': availableQty, // Pass the max available quantity
                  'description': productDescription,
                  'imagePath': productImagePath,
                  'sellerId': '', // Add seller ID if available
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
            child: const Text(
              'Buy Now',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return _buildPlaceholderImage();
    }
    
    return Image.network(
      imagePath,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
            SizedBox(height: 8),
            Text('No Image Available', 
                 style: TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingStars() {
    return Row(
      children: List.generate(5, (index) => const Icon(
        Icons.star,
        color: Colors.amber,
        size: 20,
      )),
    );
  }

  Widget _buildSellerInfo() {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.teal[100],
          radius: 25,
          child: Icon(Icons.store, color: Colors.teal[700], size: 28),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sold by',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            Text(
              'Local Farmer',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}