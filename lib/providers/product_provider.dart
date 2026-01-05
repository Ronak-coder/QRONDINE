import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/category.dart' as models;
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../config/constants.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<models.Category> _categories = [];
  List<String> _wishlist = [];
  bool _isLoading = false;
  String? _error;
  
  List<Product> get products => _products;
  List<models.Category> get categories => _categories;
  List<String> get wishlist => _wishlist;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  List<Product> get featuredProducts {
    return _products.where((p) => p.isFeatured).toList();
  }

  // Initialize
  Future<void> initialize() async {
    await loadWishlist();
    await loadUserRatings();
    await fetchProducts();
    await fetchCategories();
  }

  // Fetch products
  Future<void> fetchProducts({String? categoryId, String? query}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final products = await ApiService.getProducts(
        categoryId: categoryId,
        query: query,
      );
      _products = products;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load products';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch categories
  Future<void> fetchCategories() async {
    try {
      final categories = await ApiService.getCategories();
      _categories = categories;
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to load categories: $e');
    }
  }

  // Get product by ID
  Product? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get products by category
  List<Product> getProductsByCategory(String categoryId) {
    return _products.where((p) => p.categoryId == categoryId).toList();
  }

  // Search products
  List<Product> searchProducts(String query) {
    final lowerQuery = query.toLowerCase();
    return _products.where((p) {
      return p.name.toLowerCase().contains(lowerQuery) ||
          p.description.toLowerCase().contains(lowerQuery) ||
          p.categoryName.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Filter products
  List<Product> filterProducts({
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool? inStock,
  }) {
    return _products.where((p) {
      if (minPrice != null && p.finalPrice < minPrice) return false;
      if (maxPrice != null && p.finalPrice > maxPrice) return false;
      if (minRating != null && p.rating < minRating) return false;
      if (inStock == true && !p.isInStock) return false;
      return true;
    }).toList();
  }

  // Sort products
  void sortProducts(String sortBy) {
    switch (sortBy) {
      case 'price_low':
        _products.sort((a, b) => a.finalPrice.compareTo(b.finalPrice));
        break;
      case 'price_high':
        _products.sort((a, b) => b.finalPrice.compareTo(a.finalPrice));
        break;
      case 'rating':
        _products.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'newest':
        _products.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'popular':
        _products.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
    }
    notifyListeners();
  }

  // Wishlist management
  Future<void> loadWishlist() async {
    try {
      final wishlistJson = StorageService.getJsonList(AppConstants.wishlistKey);
      if (wishlistJson != null) {
        _wishlist = wishlistJson.map((item) => item['id'] as String).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to load wishlist: $e');
    }
  }

  Future<void> _saveWishlist() async {
    try {
      final wishlistData = _wishlist.map((id) => {'id': id}).toList();
      await StorageService.saveJsonList(AppConstants.wishlistKey, wishlistData);
    } catch (e) {
      debugPrint('Failed to save wishlist: $e');
    }
  }

  void toggleWishlist(String productId) {
    if (_wishlist.contains(productId)) {
      _wishlist.remove(productId);
    } else {
      _wishlist.add(productId);
    }
    _saveWishlist();
    notifyListeners();
  }

  bool isInWishlist(String productId) {
    return _wishlist.contains(productId);
  }

  List<Product> getWishlistProducts() {
    return _products.where((p) => _wishlist.contains(p.id)).toList();
  }

  // User Ratings Management
  Map<String, double> _userRatings = {};
  static const String _ratingsKey = 'user_product_ratings';

  Future<void> loadUserRatings() async {
    try {
      final ratingsJson = StorageService.getJson(_ratingsKey);
      if (ratingsJson != null) {
        _userRatings = ratingsJson.map((key, value) => MapEntry(key, (value as num).toDouble()));
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to load ratings: $e');
    }
  }

  Future<void> _saveUserRatings() async {
    try {
      await StorageService.saveJson(_ratingsKey, _userRatings);
    } catch (e) {
      debugPrint('Failed to save ratings: $e');
    }
  }

  Future<void> setUserRating(String productId, double rating) async {
    _userRatings[productId] = rating;
    await _saveUserRatings();
    notifyListeners();
  }

  double? getUserRating(String productId) {
    return _userRatings[productId];
  }

  // Get products with rating >= 4.5 (Best Products)
  List<Product> getBestProducts() {
    return _products.where((p) => p.rating >= 4.5).toList();
  }

  // Get effective rating (user rating if exists, otherwise default)
  double getEffectiveRating(String productId) {
    return _userRatings[productId] ?? getProductById(productId)?.rating ?? 0.0;
  }
}
