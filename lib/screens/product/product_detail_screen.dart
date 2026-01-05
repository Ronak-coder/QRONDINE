import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/cart_item.dart';
import '../../widgets/common/custom_button.dart';
import '../../utils/helpers.dart';
import '../../config/theme.dart';


class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;
  int _quantity = 1;
  Map<String, String> _selectedVariants = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          final product = productProvider.getProductById(widget.productId);

          if (product == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return CustomScrollView(
            slivers: [
              // App Bar with Image
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      PageView.builder(
                        itemCount: product.images.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final imageUrl = product.images[index];
                          return imageUrl.startsWith('http')
                              ? CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.chair, size: 64),
                                  ),
                                )
                              : Image.asset(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.chair, size: 64),
                                  ),
                                );
                        },
                      ),
                      // Image Indicator
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            product.images.length,
                            (index) => Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentImageIndex == index
                                    ? Colors.white
                                    : Colors.white54,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Wishlist Button
                      Positioned(
                        top: 50,
                        right: 16,
                        child: IconButton(
                          icon: Icon(
                            productProvider.isInWishlist(product.id)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: productProvider.isInWishlist(product.id)
                                ? Colors.red
                                : Colors.white,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.9),
                          ),
                          onPressed: () {
                            productProvider.toggleWishlist(product.id);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Product Details
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),

                      // Category
                      Text(
                        product.categoryName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Rating
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: product.rating,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 20.0,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${product.rating} (${product.reviewCount} reviews)',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // User Rating
                      Consumer<ProductProvider>(
                        builder: (context, productProv, child) {
                          final userRating = productProv.getUserRating(product.id);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rate this product:',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 8),
                              RatingBar.builder(
                                initialRating: userRating ?? 0,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemSize: 28.0,
                                itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  productProv.setUserRating(product.id, rating);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Rated ${rating.toInt()} stars!'),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                              if (userRating != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Your rating: ${userRating.toInt()} stars',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.amber[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Best Product Badge
                      if (product.rating >= 4.5)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'Best Product in Shop!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 16),

                      // Price
                      Row(
                        children: [
                          Text(
                            Helpers.formatCurrency(product.finalPrice),
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (product.hasDiscount) ...[
                            const SizedBox(width: 12),
                            Text(
                              Helpers.formatCurrency(product.price),
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: AppTheme.secondaryGradient,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${product.discountPercentage}% OFF',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Variants
                      if (product.variants != null && product.variants!.isNotEmpty)
                        ...product.variants!.map((variant) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                variant.name,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: variant.options.map((option) {
                                  final isSelected = _selectedVariants[variant.name] == option;
                                  return ChoiceChip(
                                    label: Text(option),
                                    selected: isSelected,
                                    onSelected: (selected) {
                                      setState(() {
                                        _selectedVariants[variant.name] = option;
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 16),
                            ],
                          );
                        }),

                      // Quantity Selector
                      Text(
                        'Quantity',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: _quantity > 1
                                      ? () {
                                          setState(() {
                                            _quantity--;
                                          });
                                        }
                                      : null,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    '$_quantity',
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: _quantity < product.stock
                                      ? () {
                                          setState(() {
                                            _quantity++;
                                          });
                                        }
                                      : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            product.isInStock
                                ? '${product.stock} in stock'
                                : 'Out of stock',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: product.isInStock ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Description
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomSheet: Consumer3<ProductProvider, CartProvider, AuthProvider>(
        builder: (context, productProvider, cartProvider, authProvider, child) {
          final product = productProvider.getProductById(widget.productId);
          if (product == null) return const SizedBox.shrink();

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
                text: 'Add to Cart',
                icon: Icons.shopping_cart,
                onPressed: () {
                  if (!product.isInStock) return;
                  
                  // Check if user is authenticated
                  if (!authProvider.isAuthenticated) {
                    // Show dialog to login first
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Login Required'),
                        content: const Text(
                          'Please login to add products to your cart and make purchases.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              // Navigate to login with return route
                              Navigator.pushNamed(
                                context,
                                '/login',
                                arguments: {
                                  'returnRoute': '/product',
                                  'productId': widget.productId,
                                },
                              );
                            },
                            child: const Text('Login'),
                          ),
                        ],
                      ),
                    );
                    return;
                  }
                  
                  // User is authenticated, proceed with adding to cart
                  final cartItem = CartItem(
                    product: product,
                    quantity: _quantity,
                    selectedVariants: _selectedVariants.isNotEmpty
                        ? _selectedVariants
                        : null,
                  );

                  cartProvider.addItem(cartItem);
                  Helpers.showSnackBar(
                    context,
                    'Added to cart successfully!',
                  );
                },
                width: double.infinity,
              ),

            ),
          );
        },
      ),
    );
  }
}
