import 'package:flutter/material.dart';
import 'notification_service.dart';

class CheckoutPage extends StatefulWidget {
  final Map<String, dynamic>? productDetails;

  const CheckoutPage({Key? key, this.productDetails}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  int quantity = 1;
  String deliveryAddress = '';
  String contactPhone = '';
  String deliveryNotes = '';
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _notificationService.init();
  }

  @override
  Widget build(BuildContext context) {
    final productName = widget.productDetails?['name'] ?? 'Product';
    final productPrice = widget.productDetails?['price'] ?? '0';
    final availableQuantity = int.tryParse(widget.productDetails?['quantity'] ?? '0') ?? 0;
    final imagePath = widget.productDetails?['imagePath'] ?? 'assets/images/default.png';

    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildProductSummary(productName, productPrice, imagePath),
              SizedBox(height: 20),
              _buildQuantitySelector(availableQuantity),
              SizedBox(height: 20),
              _buildDeliveryForm(),
              SizedBox(height: 20),
              _buildOrderSummary(productPrice),
              SizedBox(height: 20),
              _buildPlaceOrderButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductSummary(String productName, String productPrice, String imagePath) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey.shade300,
                  child: Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '$productPrice TZS per unit',
                    style: TextStyle(fontSize: 16, color: Colors.teal),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantitySelector(int availableQuantity) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quantity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove_circle, color: Colors.teal),
                  onPressed: quantity > 1
                      ? () {
                          setState(() {
                            quantity--;
                          });
                        }
                      : null,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.teal),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    quantity.toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle, color: Colors.teal),
                  onPressed: quantity < availableQuantity
                      ? () {
                          setState(() {
                            quantity++;
                          });
                        }
                      : null,
                ),
                Spacer(),
                Text(
                  'Available: $availableQuantity',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryForm() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Delivery Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Delivery Address',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: Icon(Icons.location_on, color: Colors.teal),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter delivery address';
                }
                return null;
              },
              onChanged: (value) {
                deliveryAddress = value;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Contact Phone',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: Icon(Icons.phone, color: Colors.teal),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter contact phone';
                }
                return null;
              },
              onChanged: (value) {
                contactPhone = value;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Delivery Notes (Optional)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: Icon(Icons.note, color: Colors.teal),
              ),
              maxLines: 2,
              onChanged: (value) {
                deliveryNotes = value;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(String productPrice) {
    final price = double.tryParse(productPrice) ?? 0;
    final subtotal = price * quantity;
    final deliveryFee = 5.0;
    final total = subtotal + deliveryFee;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal:'),
                Text('$subtotal TZS'),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Delivery Fee:'),
                Text('$deliveryFee TZS'),
              ],
            ),
            Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  '$total TZS',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceOrderButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _placeOrder();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        padding: EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text('Place Order'),
    );
  }

  void _placeOrder() {
    final productName = widget.productDetails?['name'] ?? 'Product';
    final productPrice = widget.productDetails?['price'] ?? '0';
    final price = double.tryParse(productPrice) ?? 0;
    final subtotal = price * quantity;
    final deliveryFee = 5.0;
    final total = subtotal + deliveryFee;

    // Show notification to farmer
    _notificationService.showNotification(
      'New Order Received',
      'You have received a new order for $productName x$quantity.',
    );

    // Navigate to payment page
    Navigator.pushNamed(
      context,
      '/payment',
      arguments: {
        'productName': productName,
        'quantity': quantity,
        'totalAmount': total.toString(),
        'deliveryAddress': deliveryAddress,
        'contactPhone': contactPhone,
      },
    );
  }
}
