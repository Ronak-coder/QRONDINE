import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import '../models/push_notification.dart';
import 'notification_service.dart';

// Top-level function for background message handling
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('Background message received: ${message.messageId}');
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('Data: ${message.data}');
  }
}

class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final NotificationService _notificationService = NotificationService();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  // Callback for when a notification is received
  Function(PushNotification)? onNotificationReceived;
  Function(PushNotification)? onNotificationTapped;

  Future<void> initialize() async {
    try {
      // Request notification permissions
      final settings = await _requestPermission();
      
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        if (kDebugMode) {
          print('User granted notification permission');
        }

        // Initialize local notifications
        await _notificationService.initialize();

        // Get FCM token
        _fcmToken = await _firebaseMessaging.getToken();
        if (kDebugMode) {
          print('FCM Token: $_fcmToken');
        }

        // Listen for token refresh
        _firebaseMessaging.onTokenRefresh.listen((newToken) {
          _fcmToken = newToken;
          if (kDebugMode) {
            print('FCM Token refreshed: $newToken');
          }
          // TODO: Send token to your backend server
        });

        // Set up message handlers
        await _setupMessageHandlers();

        // Subscribe to default topics
        await subscribeToDefaultTopics();

        if (kDebugMode) {
          print('FCM Service initialized successfully');
        }
      } else {
        if (kDebugMode) {
          print('User declined notification permission');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing FCM: $e');
      }
    }
  }

  Future<NotificationSettings> _requestPermission() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    return settings;
  }

  Future<void> _setupMessageHandlers() async {
    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle messages when app is in foreground
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle notification taps when app is in background or terminated
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Check if app was opened from a terminated state by tapping notification
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    if (kDebugMode) {
      print('Foreground message received: ${message.messageId}');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
      print('Data: ${message.data}');
    }

    final notification = _convertToAppNotification(message);
    
    // Show local notification
    _showLocalNotification(message);

    // Notify listeners
    if (onNotificationReceived != null) {
      onNotificationReceived!(notification);
    }
  }

  void _handleNotificationTap(RemoteMessage message) {
    if (kDebugMode) {
      print('Notification tapped: ${message.messageId}');
      print('Data: ${message.data}');
    }

    final notification = _convertToAppNotification(message);

    // Notify listeners
    if (onNotificationTapped != null) {
      onNotificationTapped!(notification);
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final title = notification.title ?? 'New Notification';
    final body = notification.body ?? '';
    final imageUrl = notification.android?.imageUrl ?? notification.apple?.imageUrl;
    final type = message.data['type'] ?? 'general';
    final id = message.messageId?.hashCode ?? DateTime.now().millisecondsSinceEpoch;

    // Determine which notification channel to use based on type
    switch (type.toLowerCase()) {
      case 'product':
      case 'new_product':
        await _notificationService.showProductNotification(
          id: id,
          title: title,
          body: body,
          imageUrl: imageUrl,
          payload: jsonEncode(message.data),
        );
        break;
      case 'offer':
      case 'discount':
      case 'best_seller':
        await _notificationService.showOfferNotification(
          id: id,
          title: title,
          body: body,
          imageUrl: imageUrl,
          payload: jsonEncode(message.data),
        );
        break;
      default:
        await _notificationService.showNotification(
          id: id,
          title: title,
          body: body,
          imageUrl: imageUrl,
          payload: jsonEncode(message.data),
        );
    }
  }

  PushNotification _convertToAppNotification(RemoteMessage message) {
    return PushNotification(
      id: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: message.notification?.title ?? 'New Notification',
      body: message.notification?.body ?? '',
      imageUrl: message.notification?.android?.imageUrl ?? 
                message.notification?.apple?.imageUrl,
      type: NotificationType.fromString(message.data['type'] ?? 'general'),
      data: message.data,
      timestamp: message.sentTime ?? DateTime.now(),
    );
  }

  // Subscribe to notification topics
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      if (kDebugMode) {
        print('Subscribed to topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error subscribing to topic $topic: $e');
      }
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      if (kDebugMode) {
        print('Unsubscribed from topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error unsubscribing from topic $topic: $e');
      }
    }
  }

  Future<void> subscribeToDefaultTopics() async {
    await subscribeToTopic('all_users');
    await subscribeToTopic('offers');
    await subscribeToTopic('new_products');
    await subscribeToTopic('best_sellers');
    
    if (kDebugMode) {
      print('Subscribed to all default topics');
    }
  }

  // Delete FCM token (useful for logout)
  Future<void> deleteToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      _fcmToken = null;
      if (kDebugMode) {
        print('FCM token deleted');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting FCM token: $e');
      }
    }
  }
}
