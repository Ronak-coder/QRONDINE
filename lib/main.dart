import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';
import 'providers/order_provider.dart';
import 'providers/user_provider.dart';
import 'services/storage_service.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/order/order_confirmation_screen.dart';
import 'models/order.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage
  await StorageService.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()..initialize()),
      ],
      child: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return MaterialApp(
            title: 'FurnitureHub',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: userProvider.themeMode,
            home: const SplashScreen(),
            onGenerateRoute: (settings) {
              if (settings.name == '/order-confirmation') {
                final order = settings.arguments as Order;
                return MaterialPageRoute(
                  builder: (context) => OrderConfirmationScreen(order: order),
                );
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
