import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../models/user.dart';
import '../../models/order.dart';
import '../../utils/helpers.dart';
import '../payment/payment_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Address? _selectedAddress;
  String? _selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    if (user?.addresses != null && user!.addresses!.isNotEmpty) {
      _selectedAddress = user.addresses!.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Consumer2<CartProvider, AuthProvider>(
        builder: (context, cart, auth, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Delivery Address Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Delivery Address',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          TextButton(
                            onPressed: _showAddressOptions,
                            child: const Text('Change'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_selectedAddress != null) ...[
                        Text(
                          _selectedAddress!.fullName,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _selectedAddress!.phone,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _selectedAddress!.fullAddress,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ] else ...[
                        Text(
                          'No address selected',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: _showAddressOptions,
                          icon: const Icon(Icons.add),
                          label: const Text('Add Address'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Order Summary
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Summary',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${cart.itemCount} items',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const Divider(height: 24),
                      _buildPriceRow('Subtotal', cart.subtotal),
                      const SizedBox(height: 8),
                      _buildPriceRow('Tax', cart.tax),
                      const SizedBox(height: 8),
                      _buildPriceRow('Shipping', cart.shippingCost),
                      const Divider(height: 24),
                      _buildPriceRow('Total', cart.total, isTotal: true),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Payment Method
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Method',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      ...['Credit/Debit Card', 'UPI', 'Cash on Delivery']
                          .map((method) => RadioListTile<String>(
                                title: Text(method),
                                value: method,
                                groupValue: _selectedPaymentMethod,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedPaymentMethod = value;
                                  });
                                },
                              )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          );
        },
      ),
      bottomSheet: Consumer<CartProvider>(
        builder: (context, cart, child) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: CustomButton(
                text: 'Place Order',
                onPressed: _canPlaceOrder() ? _placeOrder : () {},
                width: double.infinity,
              ),

            ),
          );
        },
      ),
    );
  }

  bool _canPlaceOrder() {
    return _selectedAddress != null && _selectedPaymentMethod != null;
  }

  void _placeOrder() {
    final cart = context.read<CartProvider>();
    final auth = context.read<AuthProvider>();

    if (_selectedPaymentMethod == 'Cash on Delivery') {
      // Create order directly
      _createOrder();
    } else {
      // Navigate to payment screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(
            paymentMethod: _selectedPaymentMethod!,
            amount: cart.total,
            onPaymentSuccess: _createOrder,
          ),
        ),
      );
    }
  }

  void _createOrder() {
    final cart = context.read<CartProvider>();
    final auth = context.read<AuthProvider>();
    
    final order = Order(
      id: const Uuid().v4(),
      userId: auth.user!.id,
      items: List.from(cart.items),
      subtotal: cart.subtotal,
      tax: cart.tax,
      shippingCost: cart.shippingCost,
      discount: 0,
      total: cart.total,
      status: OrderStatus.placed,
      deliveryAddress: _selectedAddress!,
      paymentMethod: _selectedPaymentMethod!,
      orderDate: DateTime.now(),
      estimatedDelivery: DateTime.now().add(const Duration(days: 5)),
    );

    // Navigate to order confirmation
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/order-confirmation',
      (route) => false,
      arguments: order,
    );

    cart.clearCart();
  }

  void _showAddressOptions() {
    final user = context.read<AuthProvider>().user;
    
    // For demo, create a mock address
    final mockAddress = Address(
      id: const Uuid().v4(),
      fullName: user?.name ?? 'John Doe',
      phone: user?.phone ?? '9876543210',
      addressLine1: '123 Main Street',
      addressLine2: 'Apartment 4B',
      city: 'Mumbai',
      state: 'Maharashtra',
      postalCode: '400001',
      country: 'India',
      isDefault: true,
    );

    setState(() {
      _selectedAddress = mockAddress;
    });

    Helpers.showSnackBar(context, 'Address selected');
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? Theme.of(context).textTheme.titleMedium
              : Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          Helpers.formatCurrency(amount),
          style: isTotal
              ? Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  )
              : Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
