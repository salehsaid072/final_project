import 'package:flutter/material.dart';

class HelpSupportPage extends StatefulWidget {
  @override
  _HelpSupportPageState createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  final List<FAQItem> _faqItems = [
    FAQItem(
      question: 'How do I place an order?',
      answer: 'To place an order, browse through the available products, select the one you want to purchase, click on "Buy Now", and follow the checkout process. You can pay using mobile money or credit card.',
    ),
    FAQItem(
      question: 'How do I list my products as a farmer?',
      answer: 'As a farmer, you can list your products by going to your dashboard, clicking on "Add Product", and filling in the required details including product name, price, quantity, and images.',
    ),
    FAQItem(
      question: 'What payment methods are accepted?',
      answer: 'We currently accept mobile money (M-Pesa, Tigo Pesa, Airtel Money) and credit/debit cards. Cash on delivery is available in selected areas.',
    ),
    FAQItem(
      question: 'How long does delivery take?',
      answer: 'Delivery times vary depending on your location. Typically, orders are delivered within 24-48 hours in urban areas and 2-5 days in rural areas.',
    ),
    FAQItem(
      question: 'Can I cancel my order?',
      answer: 'Yes, you can cancel your order before it is marked as "Processing". Once the order is being processed or has been shipped, cancellation is not possible.',
    ),
    FAQItem(
      question: 'How do I track my order?',
      answer: 'You can track your order by going to "My Orders" in your account dashboard. Each order has a status indicator showing its current stage in the delivery process.',
    ),
    FAQItem(
      question: 'What if I receive damaged products?',
      answer: 'If you receive damaged products, please take photos and contact our support team within 24 hours of delivery. We will arrange for a replacement or refund.',
    ),
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Help & Support'),
        bottom: TabBar(
          onTap: (index) {
            setState(() {
              _selectedTabIndex = index;
            });
          },
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: 'FAQs'),
            Tab(text: 'Contact Us'),
            Tab(text: 'User Guide'),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedTabIndex,
        children: [
          _buildFAQsTab(),
          _buildContactUsTab(),
          _buildUserGuideTab(),
        ],
      ),
    );
  }

  Widget _buildFAQsTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Frequently Asked Questions'),
        SizedBox(height: 16),
        ..._faqItems.map((faq) => _buildFAQItem(faq)).toList(),
        SizedBox(height: 20),
        Center(
          child: Text(
            "Can't find what you're looking for?",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        SizedBox(height: 8),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedTabIndex = 1; // Switch to Contact Us tab
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text('Contact Support'),
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }

  Widget _buildContactUsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Contact Our Support Team'),
          SizedBox(height: 16),
          Text(
            'Fill out the form below and our team will get back to you within 24 hours.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 24),
          _buildContactForm(),
          SizedBox(height: 30),
          _buildSectionHeader('Other Ways to Reach Us'),
          SizedBox(height: 16),
          _buildContactMethod(
            icon: Icons.email,
            title: 'Email',
            detail: 'support@agrimarkethub.com',
          ),
          _buildContactMethod(
            icon: Icons.phone,
            title: 'Phone',
            detail: '+255 123 456 789',
          ),
          _buildContactMethod(
            icon: Icons.location_on,
            title: 'Office',
            detail: 'AgriMarket Hub, Dar es Salaam, Tanzania',
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildUserGuideTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildSectionHeader('User Guide'),
        SizedBox(height: 16),
        _buildGuideSection(
          title: 'For Buyers',
          steps: [
            'Create an account or login to your existing account',
            'Browse products by category or search for specific items',
            'Select a product to view its details',
            'Click "Buy Now" to proceed to checkout',
            'Enter delivery information and select payment method',
            'Complete the payment process',
            'Track your order in the "My Orders" section',
          ],
          icon: Icons.shopping_cart,
        ),
        SizedBox(height: 24),
        _buildGuideSection(
          title: 'For Farmers',
          steps: [
            'Create an account as a Farmer or login to your existing account',
            'Complete your profile with all required documents for verification',
            'Once verified, access your Farmer Dashboard',
            'Add your products with details and images',
            'Monitor orders and confirm payments',
            'Track your sales and transactions',
            'Update your inventory as products are sold',
          ],
          icon: Icons.agriculture,
        ),
        SizedBox(height: 24),
        _buildGuideSection(
          title: 'Managing Your Account',
          steps: [
            'Update your profile information in the Profile section',
            'Change your password in Settings > Change Password',
            'Enable or disable notifications in Settings',
            'View your transaction history in the Transactions section',
            'Update your payment methods in Settings',
          ],
          icon: Icons.person,
        ),
        SizedBox(height: 30),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.teal.shade800,
          ),
        ),
        Divider(color: Colors.teal.shade200, thickness: 2),
      ],
    );
  }

  Widget _buildFAQItem(FAQItem faq) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ExpansionTile(
        title: Text(
          faq.question,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              faq.answer,
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
        leading: Icon(Icons.question_answer, color: Colors.teal),
        childrenPadding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  Widget _buildContactForm() {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Your Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person, color: Colors.teal),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email Address',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email, color: Colors.teal),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _messageController,
            decoration: InputDecoration(
              labelText: 'Your Message',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.message, color: Colors.teal),
              alignLabelWithHint: true,
            ),
            maxLines: 5,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your message';
              }
              return null;
            },
          ),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Submit form logic
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Your message has been sent. We\'ll get back to you soon!')),
                );
                
                // Clear form
                _nameController.clear();
                _emailController.clear();
                _messageController.clear();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                'Submit',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactMethod({
    required IconData icon,
    required String title,
    required String detail,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal.shade100,
          child: Icon(icon, color: Colors.teal),
        ),
        title: Text(title),
        subtitle: Text(detail),
      ),
    );
  }

  Widget _buildGuideSection({
    required String title,
    required List<String> steps,
    required IconData icon,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.teal.shade100,
                  child: Icon(icon, color: Colors.teal),
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ...steps.asMap().entries.map((entry) {
              int idx = entry.key;
              String step = entry.value;
              return Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.teal,
                      child: Text(
                        '${idx + 1}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        step,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}
