import 'package:flutter/material.dart';
import 'notification_service.dart';

class PaymentPage extends StatefulWidget {
  final Map<String, dynamic>? orderDetails;

  const PaymentPage({Key? key, this.orderDetails}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  String selectedPaymentMethod = 'Tigo Pesa';
  String mobileNumber = '';
  String cardNumber = '';
  String cardHolderName = '';
  String expiryDate = '';
  String cvv = '';
  bool isProcessing = false;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _notificationService.init();
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = widget.orderDetails?['totalAmount'] ?? '0';
    final productName = widget.orderDetails?['productName'] ?? 'Product';

    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildOrderSummary(productName, totalAmount),
              SizedBox(height: 20),
              _buildPaymentMethodSelector(),
              SizedBox(height: 20),
              if (selectedPaymentMethod == 'Tigo Pesa')
                _buildTigoPesaForm()
              else if (selectedPaymentMethod == 'M-Pesa')
                _buildMPesaForm()
              else if (selectedPaymentMethod == 'Credit Card')
                _buildCreditCardForm()
              else if (selectedPaymentMethod == 'Cash on Delivery')
                _buildCashOnDeliveryForm(),
              SizedBox(height: 30),
              _buildPaymentButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary(String productName, String totalAmount) {
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
                Text('Product:'),
                Text(productName, style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Amount:'),
                Text('$totalAmount TZS', 
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            RadioListTile<String>(
              title: Row(
                children: [
                  Image.asset('assets/images/tigo_pesa.png', width: 24, height: 24,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.phone_android, color: Colors.teal),
                  ),
                  SizedBox(width: 10),
                  Text('Tigo Pesa'),
                ],
              ),
              value: 'Tigo Pesa',
              groupValue: selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: Row(
                children: [
                  Icon(Icons.phone_android, color: Colors.green),
                  SizedBox(width: 10),
                  Text('M-Pesa'),
                ],
              ),
              value: 'M-Pesa',
              groupValue: selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: Row(
                children: [
                  Icon(Icons.credit_card, color: Colors.teal),
                  SizedBox(width: 10),
                  Text('Credit Card'),
                ],
              ),
              value: 'Credit Card',
              groupValue: selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: Row(
                children: [
                  Icon(Icons.delivery_dining, color: Colors.orange),
                  SizedBox(width: 10),
                  Text('Cash on Delivery'),
                ],
              ),
              value: 'Cash on Delivery',
              groupValue: selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTigoPesaForm() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset('assets/images/tigo_pesa.png', width: 30, height: 30,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.phone_android, color: Colors.teal, size: 30),
                ),
                SizedBox(width: 10),
                Text(
                  'Tigo Pesa Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 15),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Tigo Pesa Number',
                hintText: '0768XXXXXX',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: Icon(Icons.phone, color: Colors.teal),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Tigo Pesa number';
                }
                if (value.length < 10) {
                  return 'Please enter a valid mobile number';
                }
                if (!value.startsWith('076')) {
                  return 'Please enter a valid Tigo number starting with 076';
                }
                return null;
              },
              onChanged: (value) {
                mobileNumber = value;
              },
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('How to pay:', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text('1. Dial *150*01#'),
                  Text('2. Select 4 - Pay Bills'),
                  Text('3. Select 4 - Enter Business Number'),
                  Text('4. Enter 123456'),
                  Text('5. Enter amount ${widget.orderDetails?['totalAmount'] ?? "0"}'),
                  Text('6. Enter PIN to confirm'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMPesaForm() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.phone_android, color: Colors.green, size: 30),
                SizedBox(width: 10),
                Text(
                  'M-Pesa Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 15),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'M-Pesa Number',
                hintText: '0755XXXXXX',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: Icon(Icons.phone, color: Colors.green),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter M-Pesa number';
                }
                if (value.length < 10) {
                  return 'Please enter a valid mobile number';
                }
                if (!value.startsWith('075')) {
                  return 'Please enter a valid Vodacom number starting with 075';
                }
                return null;
              },
              onChanged: (value) {
                mobileNumber = value;
              },
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('How to pay:', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text('1. Dial *150*00#'),
                  Text('2. Select 4 - Pay By M-Pesa'),
                  Text('3. Select 4 - Enter Business Number'),
                  Text('4. Enter 123456'),
                  Text('5. Enter amount ${widget.orderDetails?['totalAmount'] ?? "0"}'),
                  Text('6. Enter PIN to confirm'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditCardForm() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Credit Card Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Card Number',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: Icon(Icons.credit_card, color: Colors.teal),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter card number';
                }
                if (value.length < 16) {
                  return 'Please enter a valid card number';
                }
                return null;
              },
              onChanged: (value) {
                cardNumber = value;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Card Holder Name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: Icon(Icons.person, color: Colors.teal),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter card holder name';
                }
                return null;
              },
              onChanged: (value) {
                cardHolderName = value;
              },
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Expiry Date (MM/YY)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter expiry date';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      expiryDate = value;
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter CVV';
                      }
                      if (value.length < 3) {
                        return 'Invalid CVV';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      cvv = value;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentButton() {
    return ElevatedButton(
      onPressed: isProcessing
          ? null
          : () {
              if (_formKey.currentState!.validate()) {
                _processPayment();
              }
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        padding: EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: isProcessing
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                ),
                SizedBox(width: 10),
                Text('Processing...'),
              ],
            )
          : Text('Pay Now'),
    );
  }

  Widget _buildCashOnDeliveryForm() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.delivery_dining, color: Colors.orange, size: 30),
                SizedBox(width: 10),
                Text(
                  'Cash on Delivery',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 15),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Delivery Address',
                hintText: 'Enter your full delivery address',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: Icon(Icons.location_on, color: Colors.orange),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your delivery address';
                }
                if (value.length < 10) {
                  return 'Please enter a complete address';
                }
                return null;
              },
            ),
            SizedBox(height: 15),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Contact Phone Number',
                hintText: '07XXXXXXXX',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: Icon(Icons.phone, color: Colors.orange),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter contact phone number';
                }
                if (value.length < 10) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
              onChanged: (value) {
                mobileNumber = value;
              },
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Important Information:', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text('• Payment will be collected upon delivery'),
                  Text('• Please have the exact amount ready: ${widget.orderDetails?['totalAmount'] ?? "0"} TZS'),
                  Text('• Delivery time: Within 24-48 hours'),
                  Text('• You will receive a call before delivery'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _processPayment() {
    setState(() {
      isProcessing = true;
    });

    // Simulate payment processing
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isProcessing = false;
      });

      String title;
      String message;
      IconData icon;
      Color iconColor;

      if (selectedPaymentMethod == 'Cash on Delivery') {
        title = 'Order Confirmed';
        message = 'Your order has been confirmed for Cash on Delivery.';
        icon = Icons.delivery_dining;
        iconColor = Colors.orange;
      } else {
        title = 'Payment Successful';
        message = 'Your payment for ${widget.orderDetails?['productName']} has been processed successfully.';
        icon = Icons.check_circle;
        iconColor = Colors.green;
      }

      // Show success notification
      _notificationService.showNotification(title, message);

      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(icon, color: iconColor),
              SizedBox(width: 10),
              Text(title),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message),
              SizedBox(height: 10),
              if (selectedPaymentMethod != 'Cash on Delivery')
                Text('Transaction ID: ${DateTime.now().millisecondsSinceEpoch}'),
              SizedBox(height: 10),
              Text('Amount: ${widget.orderDetails?['totalAmount']} TZS'),
              SizedBox(height: 10),
              Text('Payment Method: $selectedPaymentMethod'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/buyer_home');
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    });
  }
}
