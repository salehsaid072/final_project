import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AdminProductsPage extends StatefulWidget {
  const AdminProductsPage({Key? key}) : super(key: key);

  @override
  _AdminProductsPageState createState() => _AdminProductsPageState();
}

class _AdminProductsPageState extends State<AdminProductsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _searchQuery = '';
  String _sortBy = 'Newest First';
  final List<String> _categories = [];
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final snapshot = await _firestore.collection('categories').get();
      if (mounted) {
        setState(() {
          _categories.clear();
          _categories.addAll(snapshot.docs.map((doc) => doc.id));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading categories: $e')),
        );
      }
    }
  }

  Stream<QuerySnapshot> get _productsStream {
    Query query = _firestore.collection('products');
    
    // Apply category filter if selected
    if (_selectedCategory != null) {
      query = query.where('category', isEqualTo: _selectedCategory);
    }
    
    // Apply sorting
    if (_sortBy == 'Newest First') {
      query = query.orderBy('createdAt', descending: true);
    } else if (_sortBy == 'Price: Low to High') {
      query = query.orderBy('price', descending: true);
    } else if (_sortBy == 'Price: High to Low') {
      query = query.orderBy('price', descending: true);
    } else if (_sortBy == 'Name (A-Z)') {
      query = query.orderBy('productName', descending: false);
    } else if (_sortBy == 'Name (Z-A)') {
      query = query.orderBy('productName', descending: true);
    }
    
    return query.snapshots();
  }

  List<QueryDocumentSnapshot> _filterProducts(
    List<QueryDocumentSnapshot> products, 
    String query
  ) {
    if (query.isEmpty) return products;
    
    final lowerQuery = query.toLowerCase();
    return products.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return (data['productName']?.toString().toLowerCase().contains(lowerQuery) ?? false) ||
             (data['description']?.toString().toLowerCase().contains(lowerQuery) ?? false) ||
             (data['farmerName']?.toString().toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  Future<void> _deleteProduct(String productId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _firestore.collection('products').doc(productId).delete();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product deleted successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting product: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
        actions: [
          // Search button
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _ProductSearchDelegate(firestore: _firestore),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters and sort
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Category filter
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    ),
                    hint: const Text('All Categories'),
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All Categories'),
                      ),
                      ..._categories.map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          )),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Sort dropdown
                DropdownButton<String>(
                  value: _sortBy,
                  items: const [
                    DropdownMenuItem(value: 'Newest First', child: Text('Newest')),
                    DropdownMenuItem(value: 'Price: Low to High', child: Text('Price: Low to High')),
                    DropdownMenuItem(value: 'Price: High to Low', child: Text('Price: High to Low')),
                    DropdownMenuItem(value: 'Name (A-Z)', child: Text('Name (A-Z)')),
                    DropdownMenuItem(value: 'Name (Z-A)', child: Text('Name (Z-A)')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _sortBy = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          // Product list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _productsStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final products = snapshot.data?.docs ?? [];
                final filteredProducts = _filterProducts(products, _searchQuery);

                if (filteredProducts.isEmpty) {
                  return const Center(child: Text('No products found'));
                }

                return ListView.builder(
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    final data = product.data() as Map<String, dynamic>;
                    final imageUrl = (data['images'] != null && (data['images'] as List).isNotEmpty)
                        ? data['images'][0]
                        : 'https://via.placeholder.com/150';

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[200],
                            child: const Center(child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported),
                          ),
                        ),
                        title: Text(data['productName'] ?? 'No Name'),
                        subtitle: Text('TZS ${data['price']?.toStringAsFixed(2) ?? '0.00'} • ${data['category'] ?? 'No Category'}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                // TODO: Implement edit product
                                _showEditProductDialog(product.id, data);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteProduct(product.id),
                            ),
                          ],
                        ),
                        onTap: () {
                          // TODO: Show product details
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add new product
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showEditProductDialog(String productId, Map<String, dynamic> productData) {
    // TODO: Implement edit product dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Product'),
        content: const Text('Edit product functionality will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _ProductSearchDelegate extends SearchDelegate {
  final FirebaseFirestore firestore;
  
  _ProductSearchDelegate({required this.firestore});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('products')
          .orderBy('productName')
          .startAt([query]).endAt(['$query\uf8ff']).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final products = snapshot.data?.docs ?? [];

        if (products.isEmpty) {
          return const Center(child: Text('No products found'));
        }

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            final data = product.data() as Map<String, dynamic>;
            final imageUrl = (data['images'] != null && (data['images'] as List).isNotEmpty)
                ? data['images'][0]
                : 'https://via.placeholder.com/150';

            return ListTile(
              leading: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey[200],
                ),
                errorWidget: (context, url, error) => Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
              title: Text(data['productName'] ?? 'No Name'),
              subtitle: Text('TZS ${data['price']?.toStringAsFixed(2) ?? '0.00'}'),
              onTap: () {
                // TODO: Navigate to product details or edit screen
              },
            );
          },
        );
      },
    );
  }
}
