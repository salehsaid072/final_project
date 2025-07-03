import 'package:flutter/material.dart';

class ProductListingPage extends StatefulWidget {
  final String category;

  const ProductListingPage({Key? key, required this.category}) : super(key: key);

  @override
  _ProductListingPageState createState() => _ProductListingPageState();
}

class _ProductListingPageState extends State<ProductListingPage> {
  String searchQuery = '';
  String sortBy = 'Price: Low to High';
  
  // Sample products data - in a real app, this would come from a database
  final List<Map<String, dynamic>> allProducts = [
    {
      'id': '1',
      'name': 'Fresh Tomatoes',
      'price': '10',
      'quantity': '50',
      'description': 'Fresh organic tomatoes from local farms',
      'category': 'Vegetables',
      'farmer': 'John Doe',
      'location': 'Arusha',
      'rating': 4.5,
      'imagePath': 'assets/images/tomatoes.jpg',
    },
    {
      'id': '2',
      'name': 'Red Onions',
      'price': '8',
      'quantity': '100',
      'description': 'Premium quality red onions',
      'category': 'Vegetables',
      'farmer': 'Mary Smith',
      'location': 'Moshi',
      'rating': 4.2,
      'imagePath': 'assets/images/onions.jpg',
    },
    {
      'id': '3',
      'name': 'Ripe Bananas',
      'price': '12',
      'quantity': '80',
      'description': 'Sweet and ripe bananas',
      'category': 'Fruits',
      'farmer': 'James Wilson',
      'location': 'Dar es Salaam',
      'rating': 4.7,
      'imagePath': 'assets/images/bananas.jpg',
    },
    {
      'id': '4',
      'name': 'Fresh Maize',
      'price': '15',
      'quantity': '60',
      'description': 'Freshly harvested maize',
      'category': 'Grains',
      'farmer': 'Sarah Johnson',
      'location': 'Morogoro',
      'rating': 4.0,
      'imagePath': 'assets/images/maize.jpg',
    },
    {
      'id': '5',
      'name': 'Avocados',
      'price': '20',
      'quantity': '40',
      'description': 'Creamy and ripe avocados',
      'category': 'Fruits',
      'farmer': 'Michael Brown',
      'location': 'Iringa',
      'rating': 4.8,
      'imagePath': 'assets/images/avocados.jpg',
    },
  ];

  List<Map<String, dynamic>> get filteredProducts {
    List<Map<String, dynamic>> result = List.from(allProducts);
    
    // Filter by category if not 'All'
    if (widget.category != 'All') {
      result = result.where((product) => product['category'] == widget.category).toList();
    }
    
    // Filter by search query
    if (searchQuery.isNotEmpty) {
      result = result.where((product) => 
        product['name'].toLowerCase().contains(searchQuery.toLowerCase()) ||
        product['description'].toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();
    }
    
    // Sort products
    if (sortBy == 'Price: Low to High') {
      result.sort((a, b) => (double.parse(a['price'])).compareTo(double.parse(b['price'])));
    } else if (sortBy == 'Price: High to Low') {
      result.sort((a, b) => (double.parse(b['price'])).compareTo(double.parse(a['price'])));
    } else if (sortBy == 'Rating') {
      result.sort((a, b) => (b['rating']).compareTo(a['rating']));
    }
    
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(widget.category == 'All' ? 'All Products' : widget.category),
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: filteredProducts.isEmpty
                ? _buildEmptyState()
                : _buildProductGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: Icon(Icons.search, color: Colors.teal),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.teal),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text('Sort by: ', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 8),
              Expanded(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: sortBy,
                  items: [
                    'Price: Low to High',
                    'Price: High to Low',
                    'Rating',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        sortBy = newValue;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No products found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Try changing your search or filter criteria',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/product_details',
          arguments: product,
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                product['imagePath'],
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 120,
                  color: Colors.grey.shade300,
                  child: Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product['name'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  // Price
                  Text(
                    '${product['price']} TZS',
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  // Rating
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 4),
                      Text(
                        product['rating'].toString(),
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Buy Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/checkout',
                          arguments: product,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: EdgeInsets.symmetric(vertical: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Buy Now', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
