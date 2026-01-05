import 'cart_item.dart';
import 'user.dart';

class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double subtotal;
  final double tax;
  final double shippingCost;
  final double discount;
  final double total;
  final OrderStatus status;
  final Address deliveryAddress;
  final String paymentMethod;
  final String? paymentId;
  final DateTime orderDate;
  final DateTime? estimatedDelivery;
  final DateTime? deliveredDate;
  final List<OrderStatusUpdate>? statusHistory;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    this.tax = 0,
    this.shippingCost = 0,
    this.discount = 0,
    required this.total,
    required this.status,
    required this.deliveryAddress,
    required this.paymentMethod,
    this.paymentId,
    required this.orderDate,
    this.estimatedDelivery,
    this.deliveredDate,
    this.statusHistory,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      items: (json['items'] as List)
          .map((i) => CartItem.fromJson(i))
          .toList(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      shippingCost: (json['shipping_cost'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      status: OrderStatus.fromString(json['status'] ?? 'placed'),
      deliveryAddress: Address.fromJson(json['delivery_address']),
      paymentMethod: json['payment_method'] ?? '',
      paymentId: json['payment_id'],
      orderDate: json['order_date'] != null
          ? DateTime.parse(json['order_date'])
          : DateTime.now(),
      estimatedDelivery: json['estimated_delivery'] != null
          ? DateTime.parse(json['estimated_delivery'])
          : null,
      deliveredDate: json['delivered_date'] != null
          ? DateTime.parse(json['delivered_date'])
          : null,
      statusHistory: json['status_history'] != null
          ? (json['status_history'] as List)
              .map((s) => OrderStatusUpdate.fromJson(s))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'items': items.map((i) => i.toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'shipping_cost': shippingCost,
      'discount': discount,
      'total': total,
      'status': status.value,
      'delivery_address': deliveryAddress.toJson(),
      'payment_method': paymentMethod,
      'payment_id': paymentId,
      'order_date': orderDate.toIso8601String(),
      'estimated_delivery': estimatedDelivery?.toIso8601String(),
      'delivered_date': deliveredDate?.toIso8601String(),
      'status_history': statusHistory?.map((s) => s.toJson()).toList(),
    };
  }
}

enum OrderStatus {
  placed('Placed'),
  confirmed('Confirmed'),
  processing('Processing'),
  shipped('Shipped'),
  delivered('Delivered'),
  cancelled('Cancelled'),
  returned('Returned');

  final String value;
  const OrderStatus(this.value);

  static OrderStatus fromString(String status) {
    return OrderStatus.values.firstWhere(
      (s) => s.value.toLowerCase() == status.toLowerCase(),
      orElse: () => OrderStatus.placed,
    );
  }
}

class OrderStatusUpdate {
  final OrderStatus status;
  final DateTime timestamp;
  final String? message;

  OrderStatusUpdate({
    required this.status,
    required this.timestamp,
    this.message,
  });

  factory OrderStatusUpdate.fromJson(Map<String, dynamic> json) {
    return OrderStatusUpdate(
      status: OrderStatus.fromString(json['status'] ?? 'placed'),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.value,
      'timestamp': timestamp.toIso8601String(),
      'message': message,
    };
  }
}
