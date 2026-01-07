import 'package:flutter/foundation.dart';
import '../models/push_notification.dart';
import '../services/storage_service.dart';
import '../services/fcm_service.dart';

class NotificationProvider with ChangeNotifier {
  final FCMService _fcmService = FCMService();
  List<PushNotification> _notifications = [];
  int _unreadCount = 0;

  List<PushNotification> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get hasUnreadNotifications => _unreadCount > 0;

  NotificationProvider() {
    // Listen to FCM notifications
    _fcmService.onNotificationReceived = _handleNewNotification;
    _fcmService.onNotificationTapped = _handleNotificationTapped;
  }

  Future<void> initialize() async {
    // Load saved notifications from storage
    await _loadNotifications();
    _updateUnreadCount();
  }

  void _handleNewNotification(PushNotification notification) {
    // Add to beginning of list
    _notifications.insert(0, notification);
    _updateUnreadCount();
    _saveNotifications();
    notifyListeners();
  }

  // Public method for adding notifications (useful for testing)
  void addNotification(PushNotification notification) {
    _handleNewNotification(notification);
  }

  void _handleNotificationTapped(PushNotification notification) {
    // Mark as read when tapped
    markAsRead(notification.id);
    
    // Handle navigation based on notification type
    // This will be implemented with navigation logic
    if (kDebugMode) {
      print('Notification tapped: ${notification.type.displayName}');
      print('Data: ${notification.data}');
    }
  }

  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      _updateUnreadCount();
      _saveNotifications();
      notifyListeners();
    }
  }

  void markAllAsRead() {
    bool hasChanges = false;
    _notifications = _notifications.map((notification) {
      if (!notification.isRead) {
        hasChanges = true;
        return notification.copyWith(isRead: true);
      }
      return notification;
    }).toList();

    if (hasChanges) {
      _updateUnreadCount();
      _saveNotifications();
      notifyListeners();
    }
  }

  void deleteNotification(String notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
    _updateUnreadCount();
    _saveNotifications();
    notifyListeners();
  }

  void clearAllNotifications() {
    _notifications.clear();
    _unreadCount = 0;
    _saveNotifications();
    notifyListeners();
  }

  void _updateUnreadCount() {
    _unreadCount = _notifications.where((n) => !n.isRead).length;
  }

  Future<void> _loadNotifications() async {
    try {
      final data = StorageService.getJson('notifications');
      if (data != null && data is Map) {
        final notificationsList = data['notifications'];
        if (notificationsList != null && notificationsList is List) {
          _notifications = (notificationsList as List)
              .map((item) => PushNotification.fromMap(item as Map<String, dynamic>))
              .toList();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading notifications: $e');
      }
    }
  }

  Future<void> _saveNotifications() async {
    try {
      final notificationsData = _notifications.map((n) => n.toMap()).toList();
      await StorageService.saveJson('notifications', {'notifications': notificationsData});
    } catch (e) {
      if (kDebugMode) {
        print('Error saving notifications: $e');
      }
    }
  }

  // Get notifications by type
  List<PushNotification> getNotificationsByType(NotificationType type) {
    return _notifications.where((n) => n.type == type).toList();
  }

  // Get product notifications
  List<PushNotification> get productNotifications =>
      getNotificationsByType(NotificationType.product);

  // Get offer notifications
  List<PushNotification> get offerNotifications =>
      getNotificationsByType(NotificationType.offer);

  // Get discount notifications
  List<PushNotification> get discountNotifications =>
      getNotificationsByType(NotificationType.discount);

  // Get best seller notifications
  List<PushNotification> get bestSellerNotifications =>
      getNotificationsByType(NotificationType.bestSeller);
}
