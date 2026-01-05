# 🪑 FurnitureHub - Flutter E-Commerce App

A modern, full-featured Flutter mobile furniture e-commerce application for customers to browse and purchase premium furniture items.

## ✨ Features

### 🎯 Core Functionality
- **12 Complete Screens**: Splash, Login, Signup, Home, Categories, Product List, Product Detail, Cart, Checkout, Payment, Order Confirmation, Order Tracking, Profile
- **State Management**: Provider pattern for clean, scalable architecture
- **Responsive Design**: Adaptive layouts for mobile, tablet, and desktop
- **Dark Mode**: Full dark mode support with persistent theme preference

### 🛒 Shopping Experience
- Product browsing with search, filter, and sort
- Category-based navigation
- Product details with image gallery and variants
- Shopping cart with quantity management
- Wishlist/Favorites
- Price breakdown (subtotal, tax, shipping)

### 💳 Checkout & Payments
- Address management
- Multiple payment methods (Card, UPI, COD)
- Order placement and confirmation
- Real-time order tracking
- Order history

### 🎨 Modern UI/UX
- Vibrant gradient color scheme
- Smooth animations and transitions
- Shimmer loading effects
- Empty state designs
- Pull-to-refresh
- Badge indicators

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0+)
- Dart SDK (2.17+)
- Android Studio / VS Code
- Android Emulator or Physical Device

### Installation

1. **Navigate to the project**
   ```bash
   cd flutter_ecommerce_customer
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 📱 App Screens

1. **Splash Screen** - Animated brand intro
2. **Login/Signup** - User authentication with validation
3. **Home** - Banner carousel, categories, featured products
4. **Categories** - Browse all product categories
5. **Product List** - Filter and sort products
6. **Product Detail** - Image gallery, variants, add to cart
7. **Cart** - Manage items and view price breakdown
8. **Checkout** - Address selection and payment method
9. **Payment** - Secure payment processing
10. **Order Confirmation** - Success animation with order details
11. **Order Tracking** - Visual timeline of order status
12. **Profile** - User settings and preferences

## 🏗️ Project Structure

```
lib/
├── config/           # App configuration (theme, routes, constants)
├── models/           # Data models (Product, Order, User, etc.)
├── providers/        # State management (Provider classes)
├── services/         # API and storage services
├── screens/          # All app screens
├── widgets/          # Reusable widgets
├── utils/            # Helper functions and validators
└── main.dart         # App entry point
```

## 🔧 Technologies Used

- **Flutter** - Cross-platform mobile framework
- **Provider** - State management
- **SharedPreferences** - Local data persistence
- **CachedNetworkImage** - Image caching
- **Shimmer** - Loading animations
- **GoogleFonts** - Custom typography
- **FlutterRatingBar** - Product ratings

## 🎨 Design System

### Color Palette
- **Primary**: Purple-Blue Gradient (#6C5CE7 → #A29BFE)
- **Secondary**: Pink-Yellow Gradient (#FD79A8 → #FDCB6E)
- **Accent**: Cyan (#00CEC9)

### Typography
- **Headings**: Poppins
- **Body**: Inter

## 🔐 Authentication

Currently using mock authentication for demonstration. Login with any email/password combination to access the app.

## 💾 Data Persistence

- Cart items persist across app restarts
- Theme preference saved locally
- Wishlist stored in local storage
- Authentication session management

## 🧪 Mock Data

The app includes mock data for demonstration:
- 20 sample products
- 5 categories (Electronics, Fashion, Home & Kitchen, Beauty, Sports)
- Realistic product attributes (prices, ratings, variants)

## 🌐 API Integration

The app is structured to easily integrate with a real backend:
1. Update `ApiService` in `lib/services/api_service.dart`
2. Replace mock methods with actual API calls
3. Update `AppConstants.baseUrl` with your API endpoint

## 🎯 Key Features Summary

✅ 12 Complete Screens  
✅ Provider State Management  
✅ Responsive Design  
✅ Dark Mode Support  
✅ Cart Persistence  
✅ Wishlist  
✅ Search & Filter  
✅ Mock API Ready  
✅ Modern UI/UX  
✅ Form Validation  

**Ready for backend integration and production deployment!**
