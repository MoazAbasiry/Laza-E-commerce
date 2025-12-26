import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

// استيراد الـ Providers
import 'providers/theme_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/order_provider.dart'; // لربط الطلبات [cite: 66, 100]
import 'providers/card_provider.dart';  // لربط البطاقات البنكية [cite: 23, 28]
import 'providers/address_provider.dart'; // لربط العناوين [cite: 220]
import 'providers/review_provider.dart'; // لربط التقييمات

// استيراد الشاشات الأساسية
import 'screens/splash_screen.dart';               
import 'screens/intro_screen.dart';                
import 'screens/auth/get_started_screen.dart';     
import 'screens/auth/signup_screen.dart';          
import 'screens/auth/login_screen.dart';           
import 'screens/home/home_screen.dart';            

// استيراد شاشات استعادة كلمة المرور
import 'screens/auth/forgot_password.dart'; 
import 'screens/auth/verification_code_screen.dart'; 
import 'screens/auth/new_password_screen.dart';      

// استيراد شاشات الملف الشخصي
import 'screens/profile/profile_screen.dart';
import 'screens/profile/orders_screen.dart';
import 'screens/profile/account_info_screen.dart'; 
import 'screens/profile/password_screen.dart';     
import 'screens/profile/settings_screen.dart';     
import 'screens/profile/my_cards_screen.dart';     
import 'screens/profile/add_card_screen.dart'; 

// باقي الشاشات
import 'screens/home/product_details.dart'; 
import 'screens/cart/cart_screen.dart';
import 'screens/wishlist/wishlist_screen.dart';
import 'screens/cart/order_confirmed_screen.dart';
import 'screens/home/reviews_screen.dart';
import 'screens/home/add_review_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); 
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),      
        ChangeNotifierProvider(create: (_) => FavoritesProvider()), 
        ChangeNotifierProvider(create: (_) => OrderProvider()), // تفعيل موفر الطلبات [cite: 100]
        ChangeNotifierProvider(create: (_) => CardProvider()),  // تفعيل موفر البطاقات [cite: 28]
        ChangeNotifierProvider(create: (_) => AddressProvider()), // تفعيل موفر العناوين [cite: 220]
        ChangeNotifierProvider(create: (_) => ReviewProvider()), // تفعيل موفر التقييمات
      ],
      child: const LazaApp(),
    ),
  );
}

class LazaApp extends StatelessWidget {
  const LazaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Laza',
          themeMode: themeProvider.themeMode, 
          theme: ThemeProvider.lightTheme, 
          darkTheme: ThemeProvider.darkTheme, 
          initialRoute: '/splash',
          routes: {
            '/splash': (context) => const SplashScreen(),
            '/intro': (context) => const IntroScreen(),        
            '/get-started': (context) => const GetStartedScreen(), 
            '/signup': (context) => const SignupScreen(),      
            '/login': (context) => const LoginScreen(),        
            '/home': (context) => const HomeScreen(), 
            '/forgot-password': (context) => const ForgotPasswordScreen(),
            '/verification': (context) => const VerificationCodeScreen(),
            '/new-password': (context) => const NewPasswordScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/product-details': (context) => ProductDetailsScreen(
                  product: ModalRoute.of(context)!.settings.arguments,
                ),
            '/reviews': (context) => const ReviewsScreen(),
            '/add-review': (context) => const AddReviewScreen(),
            '/cart': (context) => const CartScreen(),
            '/wishlist': (context) => const WishlistScreen(),
            '/order-confirmed': (context) => const OrderConfirmedScreen(),
            '/orders': (context) => const OrdersScreen(), 
            '/account-info': (context) => const AccountInfoScreen(),
            '/password': (context) => const PasswordScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/my-cards': (context) => const MyCardsScreen(),
            '/add-card': (context) => const AddCardScreen(),
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(builder: (context) => const IntroScreen());
          },
        );
      },
    );
  }
}