import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../services/storage_service.dart';
import '../config/constants.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  
  List<CartItem> get items => _items;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  
  double get subtotal {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }
  
  double get tax => subtotal * 0.18; // 18% GST
  
  double get shippingCost {
    if (subtotal == 0) return 0;
    if (subtotal > 999) return 0; // Free shipping over ₹999
    return 50;
  }
  
  double get total => subtotal + tax + shippingCost;

  // Initialize cart from storage
  Future<void> initialize() async {
    try {
      final cartData = StorageService.getJsonList(AppConstants.cartDataKey);
      if (cartData != null) {
        _items = cartData.map((json) => CartItem.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to load cart: $e');
    }
  }

  // Save cart to storage
  Future<void> _saveCart() async {
    try {
      final cartData = _items.map((item) => item.toJson()).toList();
      await StorageService.saveJsonList(AppConstants.cartDataKey, cartData);
    } catch (e) {
      debugPrint('Failed to save cart: $e');
    }
  }

  // Add item to cart
  void addItem(CartItem newItem) {
    // Check if item already exists
    final existingIndex = _items.indexWhere((item) => item.isSameProduct(newItem));
    
    if (existingIndex >= 0) {
      // Update quantity
      _items[existingIndex].quantity += newItem.quantity;
    } else {
      // Add new item
      _items.add(newItem);
    }
    
    _saveCart();
    notifyListeners();
  }

  // Remove item from cart
  void removeItem(int index) {
    _items.removeAt(index);
    _saveCart();
    notifyListeners();
  }

  // Update quantity
  void updateQuantity(int index, int quantity) {
    if (quantity <= 0) {
      removeItem(index);
      return;
    }
    
    _items[index].quantity = quantity;
    _saveCart();
    notifyListeners();
  }

  // Increment quantity
  void incrementQuantity(int index) {
    _items[index].quantity++;
    _saveCart();
    notifyListeners();
  }

  // Decrement quantity
  void decrementQuantity(int index) {
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
      _saveCart();
      notifyListeners();
    }
  }

  // Clear cart
  void clearCart() {
    _items.clear();
    _saveCart();
    notifyListeners();
  }

  // Check if product is in cart
  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  // Get cart item count for a product
  int getProductQuantity(String productId) {
    return _items
        .where((item) => item.product.id == productId)
        .fold(0, (sum, item) => sum + item.quantity);
  }
}
