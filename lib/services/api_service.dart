import '../config/constants.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../models/order.dart';


class ApiService {
  static const String _baseUrl = AppConstants.baseUrl;
  static String? _authToken;

  static void setAuthToken(String? token) {
    _authToken = token;
  }

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
      };

  // Mock data - simulating API responses
  static Future<Map<String, dynamic>> _mockResponse(String endpoint, {Map<String, dynamic>? body}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Return mock data based on endpoint
    if (endpoint.contains('products')) {
      return {'success': true, 'data': _getMockProducts()};
    } else if (endpoint.contains('categories')) {
      return {'success': true, 'data': _getMockCategories()};
    } else if (endpoint.contains('login') || endpoint.contains('signup')) {
      return {
        'success': true,
        'data': {
          'token': 'mock_auth_token_${DateTime.now().millisecondsSinceEpoch}',
          'user': _getMockUser(),
        }
      };
    } else if (endpoint.contains('orders')) {
      return {'success': true, 'data': []};
    }

    return {'success': true, 'data': null};
  }

  // Authentication
  static Future<Map<String, dynamic>> login(String email, String password) async {
    return await _mockResponse('${AppConstants.loginEndpoint}', body: {
      'email': email,
      'password': password,
    });
  }

  static Future<Map<String, dynamic>> signup(String name, String email, String password) async {
    return await _mockResponse('${AppConstants.signupEndpoint}', body: {
      'name': name,
      'email': email,
      'password': password,
    });
  }

  // Products
  static Future<List<Product>> getProducts({String? categoryId, String? query}) async {
    final response = await _mockResponse('${AppConstants.productsEndpoint}');
    final data = response['data'] as List;
    return data.map((json) => Product.fromJson(json)).toList();
  }

  static Future<Product> getProductById(String id) async {
    final products = await getProducts();
    return products.firstWhere((p) => p.id == id);
  }

  // Categories
  static Future<List<Category>> getCategories() async {
    final response = await _mockResponse('${AppConstants.categoriesEndpoint}');
    final data = response['data'] as List;
    return data.map((json) => Category.fromJson(json)).toList();
  }

  // Orders
  static Future<Map<String, dynamic>> createOrder(Order order) async {
    return await _mockResponse('${AppConstants.ordersEndpoint}', body: order.toJson());
  }

  static Future<List<Order>> getOrders() async {
    final response = await _mockResponse('${AppConstants.ordersEndpoint}');
    final data = response['data'] as List;
    return data.map((json) => Order.fromJson(json)).toList();
  }

  // Mock data generators
  static List<Map<String, dynamic>> _getMockProducts() {
    final furnitureProducts = [
      // Living Room Furniture
      {'name': 'Modern L-Shape Sofa', 'category': 'Living Room', 'catId': '0', 'price': 45000, 'discount': 39999, 'imageQuery': 'l-shape-sofa'},
      {'name': 'Velvet 3-Seater Sofa', 'category': 'Living Room', 'catId': '0', 'price': 35000, 'discount': null, 'imageQuery': 'velvet-sofa'},
      {'name': 'Coffee Table Set', 'category': 'Living Room', 'catId': '0', 'price': 12000, 'discount': 9999, 'imageQuery': 'coffee-table'},
      {'name': 'TV Unit Cabinet', 'category': 'Living Room', 'catId': '0', 'price': 18000, 'discount': 15999, 'imageQuery': 'tv-cabinet'},
      {'name': 'Recliner Chair', 'category': 'Living Room', 'catId': '0', 'price': 22000, 'discount': null, 'imageQuery': 'recliner-chair'},
      
      // Bedroom Furniture
      {'name': 'King Size Bed', 'category': 'Bedroom', 'catId': '1', 'price': 38000, 'discount': 32999, 'imageQuery': 'king-bed'},
      {'name': 'Wardrobe 3-Door', 'category': 'Bedroom', 'catId': '1', 'price': 28000, 'discount': 24999, 'imageQuery': 'wardrobe'},
      {'name': 'Bedside Table Pair', 'category': 'Bedroom', 'catId': '1', 'price': 8000, 'discount': null, 'imageQuery': 'bedside-table'},
      {'name': 'Dresser with Mirror', 'category': 'Bedroom', 'catId': '1', 'price': 16000, 'discount': 13999, 'imageQuery': 'dresser-mirror'},
      {'name': 'Queen Size Bed', 'category': 'Bedroom', 'catId': '1', 'price': 32000, 'discount': null, 'imageQuery': 'queen-bed'},
      
      // Dining Furniture
      {'name': '6-Seater Dining Table', 'category': 'Dining', 'catId': '2', 'price': 42000, 'discount': 36999, 'imageQuery': 'dining-table'},
      {'name': '4-Seater Dining Set', 'category': 'Dining', 'catId': '2', 'price': 28000, 'discount': null, 'imageQuery': 'dining-set'},
      {'name': 'Dining Chairs Set of 4', 'category': 'Dining', 'catId': '2', 'price': 14000, 'discount': 11999, 'imageQuery': 'dining-chairs'},
      {'name': 'Buffet Cabinet', 'category': 'Dining', 'catId': '2', 'price': 22000, 'discount': null, 'imageQuery': 'buffet-cabinet'},
      
      // Office Furniture
      {'name': 'Executive Office Desk', 'category': 'Office', 'catId': '3', 'price': 24000, 'discount': 19999, 'imageQuery': 'office-desk'},
      {'name': 'Ergonomic Office Chair', 'category': 'Office', 'catId': '3', 'price': 12000, 'discount': 9999, 'imageQuery': 'office-chair'},
      {'name': 'Bookshelf 5-Tier', 'category': 'Office', 'catId': '3', 'price': 8000, 'discount': null, 'imageQuery': 'bookshelf'},
      {'name': 'Study Table', 'category': 'Office', 'catId': '3', 'price': 9500, 'discount': 7999, 'imageQuery': 'study-desk'},
      
      // Outdoor Furniture
      {'name': 'Patio Dining Set', 'category': 'Outdoor', 'catId': '4', 'price': 32000, 'discount': 27999, 'imageQuery': 'patio-set'},
      {'name': 'Garden Bench', 'category': 'Outdoor', 'catId': '4', 'price': 8000, 'discount': null, 'imageQuery': 'garden-bench'},
    ];

    return List.generate(furnitureProducts.length, (index) {
      final item = furnitureProducts[index];
      final String name = item['name'] as String;
      final int price = item['price'] as int;
      final int? discount = item['discount'] as int?;
      final String imageQuery = item['imageQuery'] as String;
      
      return {
        'id': 'prod_$index',
        'name': name,
        'description': 'Premium quality ${name.toLowerCase()} crafted with finest materials. Perfect for modern homes. Features sturdy construction, elegant design, and long-lasting durability.',
        'price': price.toDouble(),
        'discount_price': discount?.toDouble(),
        'images': [
          'assets/images/products/chair.png',
          'assets/images/products/chair.png',
          'assets/images/products/chair.png',
        ],
        'category_id': item['catId'],
        'category_name': item['category'],
        'rating': 4.0 + (index % 3) * 0.3,
        'review_count': 25 + (index * 8),
        'stock': 5 + index,
        'variants': index % 3 == 0
            ? [
                {'name': 'Color', 'options': ['Brown', 'White', 'Black', 'Natural Wood']},
                {'name': 'Material', 'options': ['Solid Wood', 'Engineered Wood', 'Metal']},
              ]
            : null,
        'tags': ['furniture', 'premium', 'modern'],
        'is_featured': index < 6,
        'created_at': DateTime.now().subtract(Duration(days: index * 2)).toIso8601String(),
      };
    });
  }

  static List<Map<String, dynamic>> _getMockCategories() {
    return [
      {
        'id': '0',
        'name': 'Living Room',
        'image': 'https://picsum.photos/id/1018/600/400',
        'product_count': 85,
      },
      {
        'id': '1',
        'name': 'Bedroom',
        'image': 'https://picsum.photos/id/1027/600/400',
        'product_count': 120,
      },
      {
        'id': '2',
        'name': 'Dining',
        'image': 'https://picsum.photos/id/1015/600/400',
        'product_count': 65,
      },
      {
        'id': '3',
        'name': 'Office',
        'image': 'https://picsum.photos/id/1025/600/400',
        'product_count': 75,
      },
      {
        'id': '4',
        'name': 'Outdoor',
        'image': 'https://picsum.photos/id/1035/600/400',
        'product_count': 45,
      },
    ];
  }

  static Map<String, dynamic> _getMockUser() {
    return {
      'id': 'user_1',
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'phone': '9876543210',
      'avatar': 'https://i.pravatar.cc/150?img=1',
      'created_at': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
    };
  }
}
