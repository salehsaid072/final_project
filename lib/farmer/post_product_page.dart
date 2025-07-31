// post_product_page.dart

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/product_service.dart'; // Import ProductService
import '../models/product.dart';

class PostProductPage extends StatefulWidget {
  const PostProductPage({super.key});

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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ProductService _productService = ProductService(); // Instance ya ProductService
  
  // ... (Code zingine za State bado zinabaki)

  @override
  bool get wantKeepAlive => true;

  Widget _buildMyProductsList() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return const Center(child: Text('Please sign in to view your products'));
    }

    return StreamBuilder<List<Product>>(
      stream: _productService.getProductsStream(
        farmerId: currentUser.uid,
        sortBy: 'Newest First', // Au unaweza kuweka chaguo zingine hapa
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final products = snapshot.data ?? [];

        if (products.isEmpty) {
          return const Center(child: Text('No products found. Add your first product!'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: ListTile(
                leading: product.images.isNotEmpty
                    ? Image.network(
                        product.images[0],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => 
                            const Icon(Icons.image_not_supported, size: 50),
                      )
                    : const Icon(Icons.image, size: 50),
                title: Text(product.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('\$${product.price.toStringAsFixed(2)} • Qty: ${product.quantity}'),
                    Text('Category: ${product.category}'),
                    if (product.description.isNotEmpty)
                      Text(
                        product.description.length > 50
                            ? '${product.description.substring(0, 50)}...'
                            : product.description,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editProduct(product),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteProduct(product.id, context),
                    ),
                  ],
                ),
                onTap: () {
                  // Show product details in a dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(product.productName),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (product.images.isNotEmpty)
                              Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(product.images[0]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 16),
                            _buildDetailRow('Category:', product.category),
                            _buildDetailRow('Price:', '\$${product.price.toStringAsFixed(2)}'),
                            _buildDetailRow('Quantity:', product.quantity.toString()),
                            const SizedBox(height: 8),
                            const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(product.description),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
  
  // ... (build methods zingine zote)

  void _editProduct(Product product) {
    setState(() {
      productName = product.productName;
      price = product.price.toString();
      category = product.category;
      quantity = product.quantity.toString();
      description = product.description;
      productImageUrl = product.images.isNotEmpty ? product.images[0] : null;
      productImageBytes = null; // Clear new image
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Product'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildImageUploader(),
                const SizedBox(height: 16),
                _buildTextField('Product Name', (val) => productName = val, initialValue: productName),
                const SizedBox(height: 12),
                _buildTextField('Price', (val) => price = val, keyboardType: TextInputType.number, initialValue: price),
                const SizedBox(height: 12),
                _buildDropdown('Category', ['Fruits', 'Vegetables', 'Grains', 'Other']),
                const SizedBox(height: 12),
                _buildTextField('Quantity', (val) => quantity = val, keyboardType: TextInputType.number, initialValue: quantity),
                const SizedBox(height: 12),
                _buildTextField('Description', (val) => description = val, initialValue: description, maxLines: 3),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _updateProduct(product.id, context),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateProduct(String productId, BuildContext dialogContext) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      try {
        final double parsedPrice = double.tryParse(price) ?? 0.0;
        final int parsedQuantity = int.tryParse(quantity) ?? 0;
        
        if (parsedPrice <= 0) throw Exception('Price must be greater than 0');
        if (parsedQuantity <= 0) throw Exception('Quantity must be greater than 0');

        String? imageUrl = productImageUrl;
        if (productImageBytes != null) {
          imageUrl = await _uploadImage(productImageBytes!);
        }
        
        final updatedProduct = Product(
          id: productId,
          productName: productName.trim(),
          category: category,
          price: parsedPrice,
          quantity: parsedQuantity,
          description: description.trim(),
          images: imageUrl != null ? [imageUrl] : [],
        );
        
        await _productService.updateProduct(productId, updatedProduct);

        if (dialogContext.mounted) {
          ScaffoldMessenger.of(dialogContext).showSnackBar(const SnackBar(content: Text('Product updated successfully!')));
          Navigator.pop(dialogContext);
          _resetForm();
        }
      } catch (e) {
        if (dialogContext.mounted) {
          ScaffoldMessenger.of(dialogContext).showSnackBar(SnackBar(content: Text('Error updating product: $e')));
        }
      } finally {
        if (dialogContext.mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _deleteProduct(String productId, BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await _productService.deleteProduct(productId);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product deleted successfully')));
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting product: $e')));
        }
      }
    }
  }

  // ... (Methods zingine _pickImage, _uploadImage, _resetForm zote zinabaki)

  Future<void> _postProduct() async {
    if (_formKey.currentState!.validate() && (productImageBytes != null || productImageUrl != null)) {
      setState(() => _isLoading = true);
      
      try {
        final double parsedPrice = double.tryParse(price) ?? 0.0;
        final int parsedQuantity = int.tryParse(quantity) ?? 0;
        final currentUser = _auth.currentUser;
        
        if (currentUser == null) throw Exception('User not authenticated');
        if (parsedPrice <= 0) throw Exception('Price must be greater than 0');
        if (parsedQuantity <= 0) throw Exception('Quantity must be greater than 0');

        String? imageUrl = productImageUrl;
        if (productImageBytes != null) {
          imageUrl = await _uploadImage(productImageBytes!);
        }
        
        if (imageUrl == null) throw Exception('Please select an image');

        final newProduct = Product(
          id: '',
          productName: productName.trim(),
          category: category,
          price: parsedPrice,
          quantity: parsedQuantity,
          description: description.trim(),
          images: [imageUrl],
        );
        
        await _productService.addProduct(newProduct, currentUser.uid);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product posted successfully!')));
          _resetForm();
          DefaultTabController.of(context).animateTo(1);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
        }
      } finally {
        if (context.mounted) {
          setState(() => _isLoading = false);
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields and upload an image!')));
    }
  }

  // Build method for the main UI
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Products'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.add), text: 'Add Product'),
              Tab(icon: Icon(Icons.list), text: 'My Products'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Add Product Tab
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildImageUploader(),
                    const SizedBox(height: 20),
                    _buildTextField(
                      'Product Name',
                      (val) => productName = val,
                      initialValue: productName,
                      validator: (val) => val!.isEmpty ? 'Please enter a product name' : null,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      'Price',
                      (val) => price = val,
                      keyboardType: TextInputType.number,
                      initialValue: price,
                      validator: (val) => val!.isEmpty ? 'Please enter a price' : null,
                    ),
                    const SizedBox(height: 12),
                    _buildDropdown('Category', ['Vegetables', 'Fruits', 'Grains', 'Other']),
                    const SizedBox(height: 12),
                    _buildTextField(
                      'Quantity',
                      (val) => quantity = val,
                      keyboardType: TextInputType.number,
                      initialValue: quantity,
                      validator: (val) => val!.isEmpty ? 'Please enter a quantity' : null,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      'Description',
                      (val) => description = val,
                      initialValue: description,
                      maxLines: 3,
                      validator: (val) => val!.isEmpty ? 'Please enter a description' : null,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _postProduct,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text('Post Product', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // My Products Tab
            _buildMyProductsList(),
          ],
        ),
      ),
    );
  }

  // Build a detail row for product details
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  // Build image uploader widget
  Widget _buildImageUploader() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade100,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (productImageBytes != null)
              Image.memory(
                productImageBytes!,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            else if (productImageUrl != null)
              Image.network(
                productImageUrl!,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => 
                    _buildPlaceholderIcon(),
              )
            else
              _buildPlaceholderIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderIcon() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_photo_alternate, size: 50, color: Colors.grey),
        SizedBox(height: 8),
        Text('Tap to add product image', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  // Build text field widget
  Widget _buildTextField(
    String label,
    Function(String) onChanged, {
    TextInputType keyboardType = TextInputType.text,
    String? initialValue,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
    );
  }

  // Build dropdown widget
  Widget _buildDropdown(String label, List<String> items) {
    return DropdownButtonFormField<String>(
      value: category,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            category = newValue;
          });
        }
      },
    );
  }

  // Pick image from gallery
  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          productImageBytes = bytes;
          productImageUrl = null;
        });
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  // Upload image to Firebase Storage
  Future<String> _uploadImage(Uint8List imageBytes) async {
    try {
      final String fileName = 'product_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('product_images')
          .child(fileName);

      final UploadTask uploadTask = storageRef.putData(
        imageBytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Reset form fields
  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      productName = '';
      price = '';
      category = 'Vegetables';
      quantity = '';
      description = '';
      productImageBytes = null;
      productImageUrl = null;
      _isLoading = false;
    });
  }

  // Loading state
  bool _isLoading = false;
}