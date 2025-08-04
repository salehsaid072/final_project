// product_listing_page.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/product_service.dart';
import '../models/product.dart';
import 'product_details_page.dart';

class ProductListingPage extends StatefulWidget {
  final String category;

  const ProductListingPage({Key? key, required this.category}) : super(key: key);

  @override
  _ProductListingPageState createState() => _ProductListingPageState();
}

class _ProductListingPageState extends State<ProductListingPage> {
  String searchQuery = '';
  String sortBy = 'Newest First';
  final ProductService _productService = ProductService();

  // Sample product data
  final List<Product> sampleProducts = [
    // Fruits
    Product(
      id: 'f1',
      productName: 'Mango',
      price: 1500.0,
      description: 'Sweet and juicy mangoes, rich in vitamins A and C. Hand-picked at peak ripeness.',
      quantity: 25,
      category: 'Fruits',
      images: ['https://images.unsplash.com/photo-1553279768-865429fa0078?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60'],
    ),
    Product(
      id: 'f2',
      productName: 'Banana',
      price: 800.0,
      description: 'Fresh, ripe bananas packed with potassium and natural energy.',
      quantity: 30,
      category: 'Fruits',
      images: ['https://images.unsplash.com/photo-1571771894820-86c3e1e34455?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60'],
    ),
    Product(
      id: 'f3',
      productName: 'Pineapple',
      price: 2500.0,
      description: 'Sweet and tangy pineapple, rich in vitamin C and enzymes. Perfect for fresh juice or desserts.',
      quantity: 15,
      category: 'Fruits',
      images: ['https://images.unsplash.com/photo-1550258987-190a2d41a8ba?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60'],
    ),
    Product(
      id: 'f4',
      productName: 'Papaya',
      price: 1800.0,
      description: 'Ripe and nutritious papaya, great for digestion and rich in antioxidants.',
      quantity: 18,
      category: 'Fruits',
      images: ['https://images.unsplash.com/photo-1614151619184-8914d0e734c9?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60'],
    ),
    Product(
      id: 'f5',
      productName: 'Orange',
      price: 1200.0,
      description: 'Juicy oranges packed with vitamin C. Sweet and refreshing.',
      quantity: 35,
      category: 'Fruits',
      images: ['https://images.unsplash.com/photo-1587731558519-4d0e0c4a8c4a?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60'],
    ),
    
    // Vegetables
    Product(
      id: 'v1',
      productName: 'Spinach',
      price: 200.0,
      description: 'Fresh organic spinach, rich in iron and vitamins. Grown locally with natural fertilizers.',
      quantity: 15,
      category: 'Vegetables',
      images: ['https://images.unsplash.com/photo-1576045057995-568f588f82fb?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60'],
    ),
    Product(
      id: 'v2',
      productName: 'Carrot',
      price: 1200.0,
      description: 'Sweet and crunchy carrots, packed with beta-carotene. Organically grown and freshly harvested.',
      quantity: 20,
      category: 'Vegetables',
      images: ['https://www.bing.com/images/search?view=detailV2&ccid=hUTIHTh7&id=0AA1BF141AFE0682CFCC54BB7576EB34B7AFD9F8&thid=OIP.hUTIHTh7h94vhLcWq-ErngHaKE&mediaurl=https%3A%2F%2Fagroduka.ke%2Fimages%2Fdetailed%2F9%2FNantesjpg.jpeg&exph=1082&expw=796&q=carrot&simid=608031181198339956&form=IRPRST&ck=3A926E4D6020AE2D62A311CCE82E6821&selectedindex=3&itb=0&ajaxhist=0&ajaxserp=0&cdnurl=https%3A%2F%2Fth.bing.com%2Fth%2Fid%2FR.8544c81d387b87de2f84b716abe12b9e%3Frik%3D%252bNmvtzTrdnW7VA%26pid%3DImgRaw%26r%3D0&pivotparams=insightsToken%3Dccid_QnR1HzKh*cp_09921F6CBFCEA05C56ABF62BFFD7F788*mid_ED189A0406F587444CBDC9E8F956B871AEC1085D*simid_608048760483164404*thid_OIP.QnR1HzKhlEzjfN8Ub-2PtgHaHa&vt=0&sim=11&iss=VSI&ajaxhist=0&ajaxserp=0'],
    ),
    Product(
      id: 'v3',
      productName: 'Tomato',
      price: 1000.0,
      description: 'Fresh red tomatoes, perfect for cooking and salads. Grown locally with minimal pesticides.',
      quantity: 40,
      category: 'Vegetables',
      images: ['https://www.bing.com/images/search?view=detailV2&ccid=almNbC0o&id=5548CCF10117148B6264BAF7C3FEB612E716464E&thid=OIP.almNbC0oefM7BNKQnQ1uRAHaEK&mediaurl=https%3A%2F%2Fimages-prod.healthline.com%2Fhlcmsresource%2Fimages%2FAN_images%2Ftomatoes-1296x728-feature.jpg&cdnurl=https%3A%2F%2Fth.bing.com%2Fth%2Fid%2FR.6a598d6c2d2879f33b04d2909d0d6e44%3Frik%3DTkYW5xK2%252fsP3ug%26pid%3DImgRaw%26r%3D0&exph=728&expw=1296&q=tomato&simid=607989455593286176&FORM=IRPRST&ck=0233B8D9E33BA5DB895210D6B68981E7&selectedIndex=2&itb=0&cw=1028&ch=504&ajaxhist=0&ajaxserp=0'],
    ),
    Product(
      id: 'v4',
      productName: 'Cabbage',
      price: 1500.0,
      description: 'Fresh green cabbages, perfect for cooking and salads. Grown with sustainable farming methods.',
      quantity: 12,
      category: 'Vegetables',
      images: ['https://images.unsplash.com/photo-1540148426945-6cf22a6b2383?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60'],
    ),
    Product(
      id: 'v5',
      productName: 'Onion',
      price: 800.0,
      description: 'Fresh onions with strong flavor, essential for various culinary preparations.',
      quantity: 50,
      category: 'Vegetables',
      images: ['https://images.unsplash.com/photo-1580206672808-8dfb78895b4c?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60'],
    ),
    
    // Grains
    Product(
      id: 'g1',
      productName: 'Rice',
      price: 3500.0,
      description: 'Premium quality rice, perfect for daily meals. Well-cleaned and packaged.',
      quantity: 50,
      category: 'Grains',
      images: ['https://images.unsplash.com/photo-1593555100795-42a8a9b77d0a?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60'],
    ),
    Product(
      id: 'g2',
      productName: 'Maize (corn)',
      price: 1800.0,
      description: 'Fresh maize, perfect for roasting or boiling. Grown with sustainable farming methods.',
      quantity: 35,
      category: 'Grains',
      images: ['https://images.unsplash.com/photo-1500382017468-9049fed747ef?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60'],
    ),
    Product(
      id: 'g3',
      productName: 'Wheat',
      price: 2800.0,
      description: 'High-quality wheat grains, perfect for making flour and various baked goods.',
      quantity: 25,
      category: 'Grains',
      images: ['https://images.unsplash.com/photo-1601050690597-df0568f70950?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60'],
    ),
    Product(
      id: 'g4',
      productName: 'Millet',
      price: 3200.0,
      description: 'Nutritious millet grains, gluten-free and rich in fiber and protein.',
      quantity: 20,
      category: 'Grains',
      images: ['https://images.unsplash.com/photo-1627485937980-221c10f7b8a6?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60'],
    ),
    
    // Other
    Product(
      id: 'o1',
      productName: 'Beans',
      price: 2500.0,
      description: 'High-protein beans, great for stews and traditional dishes.',
      quantity: 40,
      category: 'Other',
      images: ['https://images.unsplash.com/photo-1598965402088-8d0d455c5b1f?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60'],
    ),
    Product(
      id: 'o2',
      productName: 'Honey',
      price: 4500.0,
      description: 'Pure, raw honey with natural sweetness and health benefits.',
      quantity: 12,
      category: 'Other',
      images: ['https://images.unsplash.com/photo-1587049352846-4a222e784d38?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60'],
    ),
    Product(
      id: 'o3',
      productName: 'Salt',
      price: 500.0,
      description: 'Pure iodized salt, essential for cooking and food preservation.',
      quantity: 100,
      category: 'Other',
      images: ['https://images.unsplash.com/photo-1603048719539-3b8b2fc423f2?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60'],
    ),
    Product(
      id: 'o4',
      productName: 'Sugar',
      price: 1200.0,
      description: 'Fine white sugar, perfect for baking and sweetening beverages.',
      quantity: 45,
      category: 'Other',
      images: ['https://images.unsplash.com/photo-1605291535552-4a7c6f335fe3?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60'],
    ),
    Product(
      id: 'o5',
      productName: 'Tea Leaves',
      price: 1800.0,
      description: 'Premium tea leaves, perfect for making aromatic and refreshing tea.',
      quantity: 30,
      category: 'Other',
      images: ['https://images.unsplash.com/photo-1564890369478-c89ca6d9cde9?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60'],
    ),
    Product(
      id: 'o6',
      productName: 'Coffee Beans',
      price: 3500.0,
      description: 'Freshly roasted coffee beans, rich in flavor and aroma.',
      quantity: 22,
      category: 'Other',
      images: ['https://images.unsplash.com/photo-1447933601403-0c6688de566e?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60'],
    ),
    Product(
      id: 'o7',
      productName: 'Cooking Oil',
      price: 2800.0,
      description: 'Pure vegetable cooking oil, perfect for frying and cooking.',
      quantity: 28,
      category: 'Other',
      images: ['https://images.unsplash.com/photo-1583947581924-860bda614c35?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(widget.category == 'All' ? 'All Products' : widget.category),
      ),
      body: FutureBuilder<List<Product>>(
        future: Future.value(sampleProducts.where((product) => 
          widget.category == 'All' || product.category == widget.category).toList()
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final products = snapshot.data ?? [];
          final filteredProducts = _filterProducts(products, searchQuery);
          
          return Column(
            children: [
              _buildSearchAndFilter(),
              Expanded(
                child: filteredProducts.isEmpty
                    ? _buildEmptyState()
                    : _buildProductGrid(filteredProducts),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Product> _filterProducts(List<Product> products, String query) {
    if (query.isEmpty) return products;
    
    final lowerQuery = query.toLowerCase();
    return products.where((product) {
      return product.productName.toLowerCase().contains(lowerQuery) ||
             product.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          if (searchQuery.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Try a different search term',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ] else ...[
            const SizedBox(height: 8),
            Text(
              'Check back later for new products',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      color: Colors.white,
      child: Column(
        children: [
          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 12),
          // Sort Dropdown
          Row(
            children: [
              const Text('Sort by: ', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: sortBy,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down, size: 24),
                      items: <String>[
                        'Newest First',
                        'Price: Low to High',
                        'Price: High to Low',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: const TextStyle(fontSize: 14)),
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildProductGrid(List<Product> products) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(context, product);
      },
    );
  }

  void _navigateToProductDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsPage(
          name: product.productName,
          price: product.price.toString(),
          quantity: '${product.quantity} units',
          description: product.description,
          imagePath: product.images.isNotEmpty ? product.images[0] : '',
        ),
        settings: RouteSettings(
          arguments: {
            'name': product.productName,
            'price': product.price.toString(),
            'quantity': '${product.quantity} units',
            'description': product.description,
            'imagePath': product.images.isNotEmpty ? product.images[0] : '',
          },
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    final imageUrl = product.images.isNotEmpty
        ? product.images[0]
        : 'https://via.placeholder.com/150';
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _navigateToProductDetail(product),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 0,
            maxHeight: double.infinity,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image Section
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  height: 100, // Reduced height
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 100,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 100,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
              // Content Section
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Product Name
                    Text(
                      product.productName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14, // Slightly smaller font
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Price
                    Text(
                      'TZS ${product.price.toStringAsFixed(0)}', // Removed decimal places
                      style: const TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Available Quantity
                    Text(
                      '${product.quantity} units',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Category Tag
                    if (product.category.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.teal[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          product.category,
                          style: TextStyle(
                            color: Colors.teal[800],
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    // View Details Button
                    SizedBox(
                      width: double.infinity,
                      height: 32, // Fixed height for button
                      child: ElevatedButton(
                        onPressed: () => _navigateToProductDetail(product),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: EdgeInsets.zero,
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                        child: const Text('View Details'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  
  }
}