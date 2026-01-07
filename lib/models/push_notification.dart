class PushNotification {
  final String id;
  final String title;
  final String body;
  final String? imageUrl;
  final NotificationType type;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final bool isRead;

  PushNotification({
    required this.id,
    required this.title,
    required this.body,
    this.imageUrl,
    required this.type,
    required this.data,
    required this.timestamp,
    this.isRead = false,
  });

  factory PushNotification.fromMap(Map<String, dynamic> map) {
    return PushNotification(
      id: map['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      imageUrl: map['imageUrl'] ?? map['image'],
      type: NotificationType.fromString(map['type'] ?? 'general'),
      data: Map<String, dynamic>.from(map['data'] ?? map),
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'])
          : DateTime.now(),
      isRead: map['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'imageUrl': imageUrl,
      'type': type.value,
      'data': data,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }

  PushNotification copyWith({
    String? id,
    String? title,
    String? body,
    String? imageUrl,
    NotificationType? type,
    Map<String, dynamic>? data,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return PushNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      data: data ?? this.data,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}

enum NotificationType {
  general,
  product,
  offer,
  discount,
  bestSeller,
  order;

  String get value {
    switch (this) {
      case NotificationType.general:
        return 'general';
      case NotificationType.product:
        return 'product';
      case NotificationType.offer:
        return 'offer';
      case NotificationType.discount:
        return 'discount';
      case NotificationType.bestSeller:
        return 'best_seller';
      case NotificationType.order:
        return 'order';
    }
  }

  static NotificationType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'product':
      case 'new_product':
        return NotificationType.product;
      case 'offer':
      case 'offers':
        return NotificationType.offer;
      case 'discount':
      case 'discounts':
        return NotificationType.discount;
      case 'best_seller':
      case 'bestseller':
      case 'best_sellers':
        return NotificationType.bestSeller;
      case 'order':
        return NotificationType.order;
      default:
        return NotificationType.general;
    }
  }

  String get displayName {
    switch (this) {
      case NotificationType.general:
        return 'General';
      case NotificationType.product:
        return 'New Product';
      case NotificationType.offer:
        return 'Special Offer';
      case NotificationType.discount:
        return 'Discount';
      case NotificationType.bestSeller:
        return 'Best Seller';
      case NotificationType.order:
        return 'Order Update';
    }
  }
}
