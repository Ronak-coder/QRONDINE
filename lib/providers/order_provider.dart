import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../services/api_service.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  bool _isLoading = false;
  String? _error;
  
  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch orders
  Future<void> fetchOrders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final orders = await ApiService.getOrders();
      _orders = orders;
      _orders.sort((a, b) => b.orderDate.compareTo(a.orderDate)); // Most recent first
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load orders';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create order
  Future<bool> createOrder(Order order) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.createOrder(order);
      
      if (response['success'] == true) {
        // Add to local orders list
        _orders.insert(0, order);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      
      _error = response['message'] ?? 'Failed to create order';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'An error occurred while creating order';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Get order by ID
  Order? getOrderById(String id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get orders by status
  List<Order> getOrdersByStatus(OrderStatus status) {
    return _orders.where((o) => o.status == status).toList();
  }

  // Get active orders (not delivered or cancelled)
  List<Order> get activeOrders {
    return _orders.where((o) {
      return o.status != OrderStatus.delivered && 
             o.status != OrderStatus.cancelled;
    }).toList();
  }

  // Get completed orders
  List<Order> get completedOrders {
    return _orders.where((o) {
      return o.status == OrderStatus.delivered || 
             o.status == OrderStatus.cancelled;
    }).toList();
  }
}
