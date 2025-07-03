import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'buyer_homepage.dart';
import 'farmer_homepage.dart';
import 'post_product_page.dart';
import 'product_details_page.dart';
import 'orders_page.dart';
import 'transactions_page.dart';
import 'settings_page.dart';
import 'admin_login_page.dart'; // Admin Login Page
import 'admin_home_page.dart'; // Admin Home Page
import 'profile_page.dart'; // Profile Page
import 'manage_users_page.dart'; // Manage Users Page
import 'products_page.dart'; // Product Page
import 'category_management.dart'; // Category Management
import 'user_verification_page.dart'; // User Verification
import 'checkout_page.dart'; // Checkout Page
import 'payment_page.dart'; // Payment Page
import 'product_listing_page.dart'; // Product Listing Page
import 'notifications_page.dart'; // Notifications Page
import 'analytics_dashboard.dart'; // Analytics Dashboard
import 'login signup screen/login_signup.dart';// Profile Page
import 'help_support_page.dart'; // Help & Support Page
import 'firebase_options.dart';   

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.web,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization failed: $e');
    print('Firebase configuration: ${DefaultFirebaseOptions.web.toString()}');
    rethrow;
  }
  
  runApp(AgriMarketApp());
}

class AgriMarketApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriMarket Hub',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login_signup', // Login/Signup screen as the first screen
      routes: {
        '/login_signup': (context) => LoginSignupScreen(),
        '/buyer_home': (context) => BuyerHomePage(),
        '/farmer_home': (context) => FarmerHomePage(),
        '/post_product': (context) => PostProductPage(),
        '/product_details': (context) => ProductDetailsPage(),
        '/orders': (context) => OrdersPage(),
        '/transactions': (context) => TransactionsPage(),
        '/settings': (context) => SettingsPage(),
        '/admin_login': (context) => AdminLoginPage(),
        '/admin_home': (context) => AdminHomePage(),
        '/profile': (context) => ProfilePage(),
        '/manage_users': (context) => ManageUsersPage(),
        '/products': (context) => ProductsPage(),
        '/analytics': (context) => AnalyticsDashboard(),
        '/categories': (context) => CategoryManagement(),
        '/user_verification': (context) => UserVerificationPage(),
        '/checkout': (context) => CheckoutPage(),
        '/payment': (context) => PaymentPage(),
        '/product_listing': (context) => ProductListingPage(category: 'All'),
        '/notifications': (context) => NotificationsPage(),
        '/help_support': (context) => HelpSupportPage(),
      },
    );
  }
}