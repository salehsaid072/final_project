import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/order.dart' as model;
import '../services/order_service.dart';

class CheckoutPage extends StatefulWidget {
  final Map<String, dynamic>? productDetails;

  const CheckoutPage({Key? key, this.productDetails}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
  
  // Add a static method to create with route arguments
  static Widget createWithArguments(Map<String, dynamic> arguments) {
    return CheckoutPage(productDetails: arguments);
  }
  
  // Format price with currency
  static String formatPrice(dynamic price) {
    if (price == null) return '0 TZS';
    
    final value = price is num 
        ? price.toDouble() 
        : double.tryParse(price.toString().replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
        
    return NumberFormat.currency(
      symbol: 'TZS ',
      decimalDigits: 0,
    ).format(value);
  }
}

class _CheckoutPageState extends State<CheckoutPage> {
  // Helper method to build product image
  Widget _buildProductImage(String imagePath, {double width = 80, double height = 80}) {
    if (imagePath.isEmpty) {
      return _buildPlaceholderImage(width: width, height: height);
    }
    
    if (imagePath.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildPlaceholderImage(width: width, height: height),
        errorWidget: (context, url, error) => _buildPlaceholderImage(width: width, height: height),
      );
    } else {
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholderImage(width: width, height: height),
      );
    }
  }
  
  Widget _buildPlaceholderImage({double width = 80, double height = 80}) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade300,
      child: const Icon(Icons.image_not_supported, color: Colors.grey),
    );
  }
  final _formKey = GlobalKey<FormState>();
  int quantity = 1;
  String fullName = '';
  String phoneNumber = '';
  String deliveryAddress = '';
  String deliveryNotes = '';
  String selectedPaymentMethod = 'Cash on Delivery'; // Default payment method
  bool _isLoading = false;
  final OrderService _orderService = OrderService();
  
  // Payment methods
  final List<Map<String, dynamic>> paymentMethods = [
    {
      'name': 'Cash on Delivery',
      'description': 'Pay in cash upon delivery',
      'icon': Icons.money_off_csred,
      'color': Colors.green,
    },
    {
      'name': 'Tigo Pesa',
      'description': 'Pay securely with Tigo Pesa',
      'icon': Icons.phone_android,
      'color': Colors.purple,
      'asset': 'assets/images/tigo_pesa.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Initialize any non-context dependent state here
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Get arguments from route if not provided via constructor
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final productDetails = args ?? widget.productDetails;
    
    if (productDetails != null && productDetails.isNotEmpty) {
      // Update quantity if it's passed in the arguments
      if (productDetails['quantity'] != null) {
        setState(() {
          quantity = productDetails['quantity'] is int 
              ? productDetails['quantity'] 
              : int.tryParse(productDetails['quantity'].toString()) ?? 1;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get product details from either widget properties or route arguments
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final productDetails = args ?? widget.productDetails ?? {};
    
    final productName = productDetails['name']?.toString() ?? 'Product';
    final productPrice = productDetails['price'] is num 
        ? productDetails['price'].toDouble() 
        : double.tryParse(productDetails['price']?.toString().replaceAll(RegExp(r'[^0-9.]'), '') ?? '0') ?? 0;
    final productImage = productDetails['imagePath']?.toString() ?? '';
    final availableQuantity = productDetails['availableQuantity'] is int 
        ? productDetails['availableQuantity'] 
        : int.tryParse(productDetails['quantity']?.toString().split(' ')[0] ?? '1') ?? 1;
    final sellerId = widget.productDetails?['sellerId'] ?? '';

    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Product Summary Card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Product Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: _buildProductImage(
                                widget.productDetails?['imagePath'] ?? '',
                                width: 80,
                                height: 80,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Product Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    CheckoutPage.formatPrice(productPrice),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Qty: $quantity',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Total Price
                    const SizedBox(height: 16),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${(productPrice * quantity).toStringAsFixed(2)} TZS',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Quantity Selector
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Quantity',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                IconButton(
                                  icon: Container(
                                    decoration: BoxDecoration(
                                      color: quantity > 1 ? Colors.teal.shade50 : Colors.grey.shade200,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.remove, color: quantity > 1 ? Colors.teal : Colors.grey),
                                  ),
                                  onPressed: quantity > 1
                                      ? () => setState(() => quantity--)
                                      : null,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    quantity.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Container(
                                    decoration: BoxDecoration(
                                      color: quantity < availableQuantity ? Colors.teal.shade50 : Colors.grey.shade200,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.add, color: quantity < availableQuantity ? Colors.teal : Colors.grey),
                                  ),
                                  onPressed: quantity < availableQuantity
                                      ? () => setState(() => quantity++)
                                      : null,
                                ),
                                const Spacer(),
                                Text(
                                  'Available: $availableQuantity',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Delivery Information Form
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Delivery Information',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Full Name',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person),
                              ),
                              validator: (value) => (value == null || value.isEmpty)
                                  ? 'Please enter your full name'
                                  : null,
                              onChanged: (value) => fullName = value,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.phone),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
                                  return 'Please enter a valid phone number';
                                }
                                return null;
                              },
                              onChanged: (value) => phoneNumber = value,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Delivery Address',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.location_on),
                              ),
                              maxLines: 2,
                              validator: (value) => (value == null || value.isEmpty)
                                  ? 'Please enter delivery address'
                                  : null,
                              onChanged: (value) => deliveryAddress = value,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Additional Notes (optional)',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                prefixIcon: Icon(Icons.note_add, color: Colors.teal),
                              ),
                              maxLines: 3,
                              onChanged: (value) => deliveryNotes = value,
                            ),
                            
                            // Payment Method Section
                            const SizedBox(height: 24),
                            const Text(
                              'Payment Method',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...paymentMethods.map((method) => Card(
                              elevation: 2,
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: selectedPaymentMethod == method['name'] 
                                      ? Colors.teal 
                                      : Colors.grey.shade300,
                                  width: selectedPaymentMethod == method['name'] ? 2 : 1,
                                ),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                leading: method['asset'] != null
                                    ? Image.asset(
                                        method['asset'],
                                        width: 40,
                                        height: 40,
                                        errorBuilder: (context, error, stackTrace) => 
                                            Icon(method['icon'], color: method['color'], size: 32),
                                      )
                                    : Icon(method['icon'], color: method['color'], size: 32),
                                title: Text(
                                  method['name'],
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                                subtitle: Text(method['description']),
                                trailing: Radio<String>(
                                  value: method['name'],
                                  groupValue: selectedPaymentMethod,
                                  onChanged: (String? value) {
                                    if (value != null) {
                                      setState(() {
                                        selectedPaymentMethod = value;
                                      });
                                    }
                                  },
                                  activeColor: Colors.teal,
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedPaymentMethod = method['name'];
                                  });
                                },
                              ),
                            )).toList(),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Order Summary
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text(
                              'Order Summary',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Subtotal', style: TextStyle(fontSize: 16)),
                                Text(
                                  '${(productPrice * quantity).toStringAsFixed(2)} TZS',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Divider(),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${(productPrice * quantity).toStringAsFixed(2)} TZS',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Place Order Button
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                await _placeOrder(
                                    productName, productPrice, sellerId);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'PLACE ORDER',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> _placeOrder(String productName, double productPrice, String sellerId) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() => _isLoading = true);
    try {
      final order = model.Order(
        id: '', // Will be generated by Firestore
        buyerName: fullName,
        productName: productName,
        quantity: quantity,
        price: productPrice,
        phoneNumber: phoneNumber,
        address: deliveryAddress,
        notes: deliveryNotes,
        status: model.Order.statusPending,
        paymentStatus: 'pending',
        sellerId: sellerId,
        timestamp: DateTime.now(),
      );
      
      // Create the order in Firestore
      final orderId = await _orderService.createOrder(order);
      
      if (mounted) {
        setState(() => _isLoading = false);
        
        // Show success dialog
        final result = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Order Placed Successfully!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order #${orderId.substring(0, 8)}'),
                const SizedBox(height: 8),
                Text('$productName x $quantity'),
                Text('Total: ${(productPrice * quantity).toStringAsFixed(2)} TZS'),
                const SizedBox(height: 16),
                const Text('The seller has been notified and will contact you soon.'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('View Orders'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Continue Shopping'),
              ),
            ],
          ),
        );
        
        // Navigate based on user choice
        if (mounted) {
          if (result == true) {
            // Continue shopping - go back to home
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else {
            // Go to orders page (you'll need to implement this)
            // Navigator.push(context, MaterialPageRoute(builder: (context) => const OrdersPage()));
            // For now, just go back to home
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to place order: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}