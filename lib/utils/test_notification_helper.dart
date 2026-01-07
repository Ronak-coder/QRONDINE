import '../services/notification_service.dart';
import '../models/push_notification.dart';
import '../providers/notification_provider.dart';

class TestNotificationHelper {
  static final NotificationService _notificationService = NotificationService();

  /// Sends a test notification to demonstrate the notification system
  static Future<void> sendTestNotification({
    required NotificationProvider notificationProvider,
    NotificationType type = NotificationType.offer,
  }) async {
    final now = DateTime.now();
    final id = now.millisecondsSinceEpoch;

    String title;
    String body;
    
    switch (type) {
      case NotificationType.product:
        title = '🪑 New Product Alert!';
        body = 'Check out our latest Modern Sofa - Limited Edition!';
        break;
      case NotificationType.offer:
        title = '🎉 Special Offer Just For You!';
        body = 'Get 25% OFF on all furniture! Shop now and save big!';
        break;
      case NotificationType.discount:
        title = '💰 Flash Sale Alert!';
        body = 'Limited time: 30% discount on dining tables. Hurry!';
        break;
      case NotificationType.bestSeller:
        title = '⭐ Bestseller Back in Stock!';
        body = 'Our popular Luxury Armchair is back! Order yours now!';
        break;
      case NotificationType.order:
        title = '📦 Order Update';
        body = 'Your order #12345 has been shipped and is on the way!';
        break;
      case NotificationType.general:
        title = '👋 Welcome to FurnitureHub!';
        body = 'Discover amazing furniture deals and new arrivals daily!';
        break;
    }

    // Show the notification using the appropriate method based on type
    switch (type) {
      case NotificationType.product:
        await _notificationService.showProductNotification(
          id: id,
          title: title,
          body: body,
          payload: '{"type":"${type.value}","productId":"12345"}',
        );
        break;
      case NotificationType.offer:
      case NotificationType.discount:
      case NotificationType.bestSeller:
        await _notificationService.showOfferNotification(
          id: id,
          title: title,
          body: body,
          payload: '{"type":"${type.value}"}',
        );
        break;
      default:
        await _notificationService.showNotification(
          id: id,
          title: title,
          body: body,
          payload: '{"type":"${type.value}"}',
        );
    }

    // Add the notification to the notification provider
    final notification = PushNotification(
      id: id.toString(),
      title: title,
      body: body,
      type: type,
      data: {'type': type.value, 'test': true},
      timestamp: now,
    );

    notificationProvider.addNotification(notification);
  }

  /// Send multiple test notifications of different types
  static Future<void> sendMultipleTestNotifications({
    required NotificationProvider notificationProvider,
  }) async {
    await sendTestNotification(
      notificationProvider: notificationProvider,
      type: NotificationType.offer,
    );

    await Future.delayed(const Duration(seconds: 1));

    await sendTestNotification(
      notificationProvider: notificationProvider,
      type: NotificationType.product,
    );

    await Future.delayed(const Duration(seconds: 1));

    await sendTestNotification(
      notificationProvider: notificationProvider,
      type: NotificationType.bestSeller,
    );
  }
}
