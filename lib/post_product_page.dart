import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart'; // For unique ID
import '../models/product.dart';
import '../services/product_service.dart';

class PostProductPage extends StatefulWidget {
  @override
  _PostProductPageState createState() => _PostProductPageState();
}

class _PostProductPageState extends State<PostProductPage> with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  String productName = '';
  String price = '';
  String category = 'Vegetables';
  String quantity = '';
  String description = '';
  Uint8List? productImageBytes;
  String? productImageUrl;

  @override
  bool get wantKeepAlive => true;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        productImageBytes = bytes;
        productImageUrl = null; // Clear any existing URL
      });
    }
  }

  Future<String> _uploadImage(Uint8List imageBytes) async {
    final fileName = const Uuid().v4();
    final ref = FirebaseStorage.instance.ref().child('product_images/$fileName.jpg');
    await ref.putData(imageBytes);
    return await ref.getDownloadURL();
  }

  void _postProduct() async {
    if (_formKey.currentState!.validate() && productImageBytes != null) {
      try {
        final double parsedPrice = double.tryParse(price) ?? 0.0;
        final int parsedQuantity = int.tryParse(quantity) ?? 0;
        String imageUrl = await _uploadImage(productImageBytes!);
        String productId = const Uuid().v4();

        // Create a Product object
        final product = Product(
          id: productId,
          productName: productName,
          category: category,
          price: parsedPrice,
          quantity: parsedQuantity,
          description: description,
          images: [imageUrl],
        );

        // Use ProductService to save the product
        final productService = ProductService();
        await productService.addProduct(product);

        // Clear form
        setState(() {
          productName = '';
          price = '';
          category = 'Vegetables';
          quantity = '';
          description = '';
          productImageBytes = null;
        });

        Navigator.pushNamed(context, '/buyer_home');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error posting product: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and upload an image!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(title: Text('Post Product')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildImageUploader(),
              SizedBox(height: 20),
              _buildTextField('Product Name', (val) => productName = val),
              SizedBox(height: 12),
              _buildTextField('Price', (val) => price = val, keyboardType: TextInputType.number),
              SizedBox(height: 12),
              _buildDropdown('Category', ['Fruits', 'Vegetables', 'Grains', 'Other']),
              SizedBox(height: 12),
              _buildTextField('Quantity', (val) => quantity = val, keyboardType: TextInputType.number),
              SizedBox(height: 12),
              _buildTextField('Description', (val) => description = val),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _postProduct,
                child: Text('Post'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploader() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: productImageBytes == null
                  ? Icon(Icons.camera_alt, size: 40, color: Colors.teal)
                  : Image.memory(
                      productImageBytes!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
            ),
            SizedBox(height: 10),
            Text(
              productImageBytes == null ? 'Upload Image' : 'Image Selected',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged, {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: (val) => val!.isEmpty ? 'Please enter $label' : null,
    );
  }

  Widget _buildDropdown(String label, List<String> options) {
    return DropdownButtonFormField<String>(
      value: category,
      items: options.map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
      onChanged: (val) => setState(() => category = val!),
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
    );
  }
}
