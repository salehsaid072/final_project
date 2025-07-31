import 'dart:async';
import 'package:flutter/material.dart';
import 'package:projectfrontend/notification_service.dart';
import 'product_listing_page.dart';

class BuyerHomePage extends StatefulWidget {
  const BuyerHomePage({super.key});

  @override
  _BuyerHomePageState createState() => _BuyerHomePageState();
}

class _BuyerHomePageState extends State<BuyerHomePage> {
  final NotificationService _notificationService = NotificationService();
  final List<String> categories = ['Fruits', 'Vegetables', 'Grains', 'Other'];
  final List<String> slideImages = [
    'assets/images/slide1.jpg',
    'assets/images/slide2.jpg',
    'assets/images/slide3.jpg',
    'assets/images/slide4.jpg',
  ];

  int _currentSlide = 0;
  late PageController _pageController;
  late Timer _timer;

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'fruits':
        return Colors.orange;
      case 'vegetables':
        return Colors.green;
      case 'dairy':
        return Colors.blue;
      case 'grains':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  @override
  void initState() {
    super.initState();
    _notificationService.init();
    _pageController = PageController(initialPage: 0);

    // Auto slide every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients) {
        final int nextPage = (_currentSlide + 1) % slideImages.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String username = ModalRoute.of(context)?.settings.arguments as String? ?? 'Buyer';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 24),
            const SizedBox(width: 8),
            const Text('AgriMarket Hub', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Help & Support',
            onPressed: () {
              Navigator.pushNamed(context, '/help_support');
            },
          ),
          PopupMenuButton<String>(
            onSelected: (String choice) {
              if (choice == 'Settings') {
                Navigator.pushNamed(context, '/settings');
              } else if (choice == 'Admin Login') {
                Navigator.pushNamed(context, '/admin_login');
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Settings', 'Admin Login'}.map((String choice) {
                return PopupMenuItem<String>(value: choice, child: Text(choice));
              }).toList();
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, $username!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Find fresh and quality farm products',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),

              



              // Slideshow
              Container(
                height: 200,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: slideImages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentSlide = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage(slideImages[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Slide indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(slideImages.length, (index) {
                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentSlide == index ? Colors.teal : Colors.grey,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),

              // Categories
              const Text(
                'Product Categories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 24),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: categories
                    .map((category) => _buildCategoryCard(context, category))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile screen'),
          const BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/buyer_home');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/profile screen');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/notifications');
          }
        },
        currentIndex: 0,
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String category) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CategoryView(category)),
      ),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _getCategoryColor(category),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                    shadows: [
                      Shadow(
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryView extends StatelessWidget {
  final String category;
  
  const CategoryView(this.category, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProductListingPage(category: category);
  }
}
