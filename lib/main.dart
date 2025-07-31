import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projectfrontend/buyer/buyer_homepage.dart';
import 'package:projectfrontend/buyer/checkout_page.dart';
import 'package:projectfrontend/buyer/help_support_page.dart';
import 'package:projectfrontend/buyer/payment_page.dart';
import 'package:projectfrontend/buyer/product_details_page.dart';
import 'package:projectfrontend/buyer/product_listing_page.dart';
import 'package:projectfrontend/farmer/farmer_homepage.dart';
import 'package:projectfrontend/farmer/post_product_page.dart';
import 'package:projectfrontend/farmer/orders_page.dart';
import 'package:projectfrontend/farmer/transactions_page.dart';
import 'package:projectfrontend/farmer/products_page.dart';
import 'package:projectfrontend/admin/admin_login_page.dart';
import 'package:projectfrontend/admin/admin_home_page.dart';
import 'package:projectfrontend/admin/manage_users_page.dart';
import 'package:projectfrontend/admin/category_management.dart';
import 'package:projectfrontend/admin/user_verification_page.dart';
import 'package:projectfrontend/notifications_page.dart';
import 'package:projectfrontend/profile%20screen/profile_screen.dart';
import 'package:projectfrontend/settings_page.dart';
import 'package:projectfrontend/login signup screen/login_signup.dart';
import 'firebase_options.dart';   
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization failed: $e');
    print('Firebase configuration: ${DefaultFirebaseOptions.currentPlatform.toString()}');
    rethrow;
  }
  
  runApp(const AgriMarketApp());
}

class AgriMarketApp extends StatelessWidget {
  const AgriMarketApp({Key? key}) : super(key: key);
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
      // Application routes
      routes: {
        // Authentication
        '/login_signup': (context) => const LoginSignupScreen(),
        
        // Buyer routes
        '/buyer_home': (context) => const BuyerHomePage(),
        '/product_details': (context) => const ProductDetailsPage(),
        '/checkout': (context) => const CheckoutPage(),
        '/payment': (context) => const PaymentPage(),
        '/product_listing': (context) => ProductListingPage(
          category: ModalRoute.of(context)?.settings.arguments as String? ?? 'All',
        ),
        
        // Farmer routes
        '/farmer_home': (context) => const FarmerHomePage(),
        '/post_product': (context) => const PostProductPage(),
        '/orders': (context) => const OrdersPage(),
        '/transactions': (context) => const TransactionsPage(),
        '/products': (context) =>  ProductsPage(),
        
        // Admin routes
        '/admin_login': (context) => const AdminLoginPage(),
        '/admin_home': (context) => const AdminHomePage(),
        '/manage_users': (context) =>  ManageUsersPage(),
        '/categories': (context) => const CategoryManagement(),
        '/user_verification': (context) => const UserVerificationPage(),
        
        // Common routes
        '/settings': (context) => const SettingsPage(),
        '/profile': (context) => const ProfileScreen(),
        '/notifications': (context) => const NotificationsPage(),
        '/help_support': (context) => const HelpSupportPage(),
      },
    );
  }
}