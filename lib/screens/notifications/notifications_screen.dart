import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/notification_provider.dart';
import '../../models/push_notification.dart';
import '../../utils/helpers.dart';
import '../../utils/test_notification_helper.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          Consumer<NotificationProvider>(
            builder: (context, notificationProvider, _) {
              if (notificationProvider.notifications.isEmpty) {
                return const SizedBox.shrink();
              }
              return PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'mark_all_read') {
                    notificationProvider.markAllAsRead();
                    Helpers.showSnackBar(context, 'All marked as read');
                  } else if (value == 'clear_all') {
                    _showClearAllDialog(context, notificationProvider);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'mark_all_read',
                    child: Text('Mark all as read'),
                  ),
                  const PopupMenuItem(
                    value: 'clear_all',
                    child: Text('Clear all'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      floatingActionButton: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, _) {
          return FloatingActionButton.extended(
            onPressed: () => _showTestNotificationMenu(context, notificationProvider),
            icon: const Icon(Icons.send),
            label: const Text('Send Test'),
            tooltip: 'Send Test Notification',
          );
        },
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, _) {
          if (notificationProvider.notifications.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              // Refresh notifications
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notificationProvider.notifications.length,
              itemBuilder: (context, index) {
                final notification = notificationProvider.notifications[index];
                return _NotificationCard(
                  notification: notification,
                  onTap: () {
                    notificationProvider.markAsRead(notification.id);
                    _handleNotificationTap(context, notification);
                  },
                  onDismiss: () {
                    notificationProvider.deleteNotification(notification.id);
                    Helpers.showSnackBar(context, 'Notification deleted');
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'ll be notified about products,\noffers, and promotions here',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showTestNotificationMenu(BuildContext context, NotificationProvider provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Send Test Notification',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildTestNotificationButton(
              context,
              provider,
              icon: Icons.local_offer_outlined,
              label: 'Special Offer',
              color: Colors.orange,
              type: NotificationType.offer,
            ),
            const SizedBox(height: 12),
            _buildTestNotificationButton(
              context,
              provider,
              icon: Icons.shopping_bag_outlined,
              label: 'New Product',
              color: Colors.blue,
              type: NotificationType.product,
            ),
            const SizedBox(height: 12),
            _buildTestNotificationButton(
              context,
              provider,
              icon: Icons.discount_outlined,
              label: 'Flash Sale',
              color: Colors.green,
              type: NotificationType.discount,
            ),
            const SizedBox(height: 12),
            _buildTestNotificationButton(
              context,
              provider,
              icon: Icons.star_outline,
              label: 'Bestseller',
              color: Colors.amber,
              type: NotificationType.bestSeller,
            ),
            const SizedBox(height: 12),
            _buildTestNotificationButton(
              context,
              provider,
              icon: Icons.receipt_long_outlined,
              label: 'Order Update',
              color: Colors.purple,
              type: NotificationType.order,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                await TestNotificationHelper.sendMultipleTestNotifications(
                  notificationProvider: provider,
                );
                if (context.mounted) {
                  Helpers.showSnackBar(context, '3 test notifications sent!');
                }
              },
              icon: const Icon(Icons.notifications_active),
              label: const Text('Send Multiple (3)'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildTestNotificationButton(
    BuildContext context,
    NotificationProvider provider, {
    required IconData icon,
    required String label,
    required Color color,
    required NotificationType type,
  }) {
    return ElevatedButton.icon(
      onPressed: () async {
        Navigator.pop(context);
        await TestNotificationHelper.sendTestNotification(
          notificationProvider: provider,
          type: type,
        );
        if (context.mounted) {
          Helpers.showSnackBar(context, 'Test notification sent!');
        }
      },
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16),
        elevation: 0,
      ),
    );
  }

  void _showClearAllDialog(BuildContext context, NotificationProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Notifications'),
        content: const Text(
          'Are you sure you want to delete all notifications? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.clearAllNotifications();
              Navigator.pop(context);
              Helpers.showSnackBar(context, 'All notifications cleared');
            },
            child: const Text(
              'Clear All',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNotificationTap(BuildContext context, PushNotification notification) {
    // Handle navigation based on notification type and data
    switch (notification.type) {
      case NotificationType.product:
      case NotificationType.bestSeller:
        final productId = notification.data['productId'] ?? notification.data['product_id'];
        if (productId != null) {
          // Navigate to product detail screen
          // Navigator.pushNamed(context, '/product-detail', arguments: productId);
          Helpers.showSnackBar(context, 'Navigate to product: $productId');
        }
        break;
      case NotificationType.offer:
      case NotificationType.discount:
        final offerId = notification.data['offerId'] ?? notification.data['offer_id'];
        if (offerId != null) {
          // Navigate to offers screen or specific offer
          Helpers.showSnackBar(context, 'Navigate to offer: $offerId');
        }
        break;
      case NotificationType.order:
        final orderId = notification.data['orderId'] ?? notification.data['order_id'];
        if (orderId != null) {
          // Navigate to order tracking screen
          Helpers.showSnackBar(context, 'Navigate to order: $orderId');
        }
        break;
      default:
        // General notification, no specific action
        break;
    }
  }
}

class _NotificationCard extends StatelessWidget {
  final PushNotification notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: notification.isRead ? 0 : 2,
        color: notification.isRead ? null : Theme.of(context).primaryColor.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: notification.isRead
                ? Colors.grey.withOpacity(0.2)
                : Theme.of(context).primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildIcon(context),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  notification.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: notification.isRead
                                        ? FontWeight.w500
                                        : FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (!notification.isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatTimestamp(notification.timestamp),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  notification.body,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                ),
                if (notification.imageUrl != null) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      notification.imageUrl!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    IconData iconData;
    Color iconColor;

    switch (notification.type) {
      case NotificationType.product:
        iconData = Icons.shopping_bag_outlined;
        iconColor = Colors.blue;
        break;
      case NotificationType.offer:
        iconData = Icons.local_offer_outlined;
        iconColor = Colors.orange;
        break;
      case NotificationType.discount:
        iconData = Icons.discount_outlined;
        iconColor = Colors.green;
        break;
      case NotificationType.bestSeller:
        iconData = Icons.star_outline;
        iconColor = Colors.amber;
        break;
      case NotificationType.order:
        iconData = Icons.receipt_long_outlined;
        iconColor = Colors.purple;
        break;
      default:
        iconData = Icons.notifications_outlined;
        iconColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 24,
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, yyyy').format(timestamp);
    }
  }
}
