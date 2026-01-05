import 'package:flutter/material.dart';
import '../../models/order.dart';
import '../../models/user.dart';
import '../../utils/helpers.dart';
import '../../config/theme.dart';


class OrderTrackingScreen extends StatelessWidget {
  final String orderId;

  const OrderTrackingScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    // Mock order data
    final order = _getMockOrder();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Tracking'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order ID: #${orderId.substring(0, 8).toUpperCase()}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Placed on ${Helpers.formatDate(order.orderDate)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Estimated Delivery
            if (order.estimatedDelivery != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient.scale(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_shipping,
                      color: AppTheme.primaryColor,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Estimated Delivery',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            Helpers.formatDate(order.estimatedDelivery!),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),

            // Order Status Timeline
            Text(
              'Order Status',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            _buildStatusTimeline(context, order),

            const SizedBox(height: 24),

            // Delivery Address
            Text(
              'Delivery Address',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.deliveryAddress.fullName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.deliveryAddress.phone,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.deliveryAddress.fullAddress,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Order Items
            Text(
              'Order Items',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ...order.items.map((item) => Card(
                  child: ListTile(
                    title: Text(item.product.name),
                    subtitle: Text('Qty: ${item.quantity}'),
                    trailing: Text(
                      Helpers.formatCurrency(item.totalPrice),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTimeline(BuildContext context, Order order) {
    final statuses = [
      OrderStatus.placed,
      OrderStatus.confirmed,
      OrderStatus.shipped,
      OrderStatus.delivered,
    ];

    final currentIndex = statuses.indexOf(order.status);

    return Column(
      children: List.generate(statuses.length, (index) {
        final status = statuses[index];
        final isCompleted = index <= currentIndex;
        final isCurrent = index == currentIndex;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppTheme.primaryColor
                        : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCompleted ? Icons.check : _getStatusIcon(status),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                if (index < statuses.length - 1)
                  Container(
                    width: 2,
                    height: 40,
                    color: isCompleted
                        ? AppTheme.primaryColor
                        : Colors.grey[300],
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status.value,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: isCompleted
                                ? AppTheme.primaryColor
                                : Colors.grey,
                            fontWeight: isCurrent
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                    ),
                    if (isCurrent) ...[
                      const SizedBox(height: 4),
                      Text(
                        'In Progress',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.primaryColor,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return Icons.receipt;
      case OrderStatus.confirmed:
        return Icons.task_alt;
      case OrderStatus.shipped:
        return Icons.local_shipping;
      case OrderStatus.delivered:
        return Icons.home;
      default:
        return Icons.circle;
    }
  }

  Order _getMockOrder() {
    return Order(
      id: orderId,
      userId: 'user_1',
      items: [],
      subtotal: 2000,
      tax: 360,
      shippingCost: 0,
      discount: 0,
      total: 2360,
      status: OrderStatus.confirmed,
      deliveryAddress: Address(
        id: 'addr_1',
        fullName: 'John Doe',
        phone: '9876543210',
        addressLine1: '123 Main Street',
        city: 'Mumbai',
        state: 'Maharashtra',
        postalCode: '400001',
      ),
      paymentMethod: 'UPI',
      orderDate: DateTime.now().subtract(const Duration(days: 1)),
      estimatedDelivery: DateTime.now().add(const Duration(days: 4)),
    );
  }
}
