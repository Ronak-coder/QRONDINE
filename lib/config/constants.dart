class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://api.example.com'; // Mock API URL
  static const String apiVersion = 'v1';
  
  // Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String signupEndpoint = '/auth/signup';
  static const String productsEndpoint = '/products';
  static const String categoriesEndpoint = '/categories';
  static const String ordersEndpoint = '/orders';
  static const String userEndpoint = '/user';
  
  // App Configuration
  static const String appName = 'FurnitureHub';
  static const String appTagline = 'Your Premium Furniture Store';
  static const int splashDuration = 3; // seconds
  static const int requestTimeout = 30; // seconds
  
  // Pagination
  static const int productsPerPage = 20;
  static const int ordersPerPage = 10;
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Image Placeholders
  static const String placeholderImage = 'https://via.placeholder.com/400';
  static const String userPlaceholder = 'https://via.placeholder.com/150';
  
  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String cartDataKey = 'cart_data';
  static const String themeKey = 'theme_mode';
  static const String wishlistKey = 'wishlist';
  
  // Payment Methods
  static const List<String> paymentMethods = [
    'Credit/Debit Card',
    'UPI',
    'Net Banking',
    'Wallet',
    'Cash on Delivery'
  ];
  
  // Order Status
  static const String orderPlaced = 'Placed';
  static const String orderConfirmed = 'Confirmed';
  static const String orderProcessing = 'Processing';
  static const String orderShipped = 'Shipped';
  static const String orderDelivered = 'Delivered';
  static const String orderCancelled = 'Cancelled';
  
  // Regex Patterns
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String phonePattern = r'^[0-9]{10}$';
  static const String passwordPattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$';
}

