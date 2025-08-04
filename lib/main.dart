import 'package:agrimarket_hub/admin/admin_home_page.dart';
import 'package:agrimarket_hub/admin/admin_login_page.dart';
import 'package:agrimarket_hub/admin/category_management.dart';
import 'package:agrimarket_hub/admin/manage_users_page.dart';
import 'package:agrimarket_hub/admin/user_verification_page.dart';
import 'package:agrimarket_hub/buyer/buyer_homepage.dart';
import 'package:agrimarket_hub/buyer/checkout_page.dart';
import 'package:agrimarket_hub/buyer/help_support_page.dart';
import 'package:agrimarket_hub/buyer/payment_page.dart';
import 'package:agrimarket_hub/buyer/product_details_page.dart';
import 'package:agrimarket_hub/buyer/product_listing_page.dart';
import 'package:agrimarket_hub/farmer/farmer_homepage.dart';
import 'package:agrimarket_hub/farmer/orders_page.dart';
import 'package:agrimarket_hub/farmer/post_product_page.dart';
import 'package:agrimarket_hub/farmer/products_page.dart';
import 'package:agrimarket_hub/farmer/transactions_page.dart';
import 'package:agrimarket_hub/login%20signup%20screen/login_signup.dart';
import 'package:agrimarket_hub/notifications_page.dart';
import 'package:agrimarket_hub/profile%20screen/profile_screen.dart';
import 'package:agrimarket_hub/services/auth_service.dart';
import 'package:agrimarket_hub/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
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
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: const AgriMarketApp(),
    ),
  );
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
        '/checkout': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return CheckoutPage.createWithArguments(args ?? {});
        },
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