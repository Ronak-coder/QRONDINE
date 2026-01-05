import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/cart/cart_item_widget.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/empty_state.dart';
import '../../utils/helpers.dart';
import '../../config/theme.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return EmptyState(
              icon: Icons.shopping_cart_outlined,
              title: 'Your cart is empty',
              subtitle: 'Add some products to get started!',
              buttonText: 'Browse Products',
              onButtonPressed: () {
                Navigator.pop(context);
              },
            );
          }

          return Column(
            children: [
              // Cart Items
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final cartItem = cart.items[index];
                    return CartItemWidget(
                      cartItem: cartItem,
                      onIncrement: () => cart.incrementQuantity(index),
                      onDecrement: () => cart.decrementQuantity(index),
                      onRemove: () {
                        cart.removeItem(index);
                        Helpers.showSnackBar(
                          context,
                          'Item removed from cart',
                        );
                      },
                    );
                  },
                ),
              ),

              // Price Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      _buildPriceRow(
                        context,
                        'Subtotal',
                        Helpers.formatCurrency(cart.subtotal),
                      ),
                      const SizedBox(height: 8),
                      _buildPriceRow(
                        context,
                        'Tax (18%)',
                        Helpers.formatCurrency(cart.tax),
                      ),
                      const SizedBox(height: 8),
                      _buildPriceRow(
                        context,
                        'Shipping',
                        cart.shippingCost > 0
                            ? Helpers.formatCurrency(cart.shippingCost)
                            : 'FREE',
                        color: cart.shippingCost == 0 ? Colors.green : null,
                      ),
                      const Divider(height: 24),
                      _buildPriceRow(
                        context,
                        'Total',
                        Helpers.formatCurrency(cart.total),
                        isTotal: true,
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'Proceed to Checkout',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CheckoutScreen(),
                            ),
                          );
                        },
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPriceRow(
    BuildContext context,
    String label,
    String value, {
    bool isTotal = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? Theme.of(context).textTheme.titleLarge
              : Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          value,
          style: isTotal
              ? Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  )
              : Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: color,
                  ),
        ),
      ],
    );
  }
}
