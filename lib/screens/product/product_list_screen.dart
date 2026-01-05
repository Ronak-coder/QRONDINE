import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product/product_card.dart';
import '../../widgets/common/loading_shimmer.dart';
import '../../widgets/common/empty_state.dart';
import '../../utils/responsive.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  final String title;
  final String? categoryId;
  final String? searchQuery;

  const ProductListScreen({
    super.key,
    required this.title,
    this.categoryId,
    this.searchQuery,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String _sortBy = 'popular';
  bool _showFilters = false;
  double? _minPrice;
  double? _maxPrice;
  double? _minRating;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
              context.read<ProductProvider>().sortProducts(value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'popular',
                child: Text('Popular'),
              ),
              const PopupMenuItem(
                value: 'price_low',
                child: Text('Price: Low to High'),
              ),
              const PopupMenuItem(
                value: 'price_high',
                child: Text('Price: High to Low'),
              ),
              const PopupMenuItem(
                value: 'rating',
                child: Text('Top Rated'),
              ),
              const PopupMenuItem(
                value: 'newest',
                child: Text('Newest'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          if (_showFilters) _buildFilters(),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                var products = widget.searchQuery != null
                    ? productProvider.searchProducts(widget.searchQuery!)
                    : widget.categoryId != null
                        ? productProvider.getProductsByCategory(widget.categoryId!)
                        : productProvider.products;

                // Apply filters
                if (_minPrice != null || _maxPrice != null || _minRating != null) {
                  products = productProvider.filterProducts(
                    minPrice: _minPrice,
                    maxPrice: _maxPrice,
                    minRating: _minRating,
                  );
                }

                if (productProvider.isLoading) {
                  return GridView.builder(
                    padding: EdgeInsets.all(context.padding),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: context.gridColumns,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) => const ProductCardShimmer(),
                  );
                }

                if (products.isEmpty) {
                  return EmptyState(
                    icon: Icons.search_off,
                    title: 'No Products Found',
                    subtitle: 'Try adjusting your filters or search query',
                    buttonText: 'Clear Filters',
                    onButtonPressed: () {
                      setState(() {
                        _minPrice = null;
                        _maxPrice = null;
                        _minRating = null;
                      });
                    },
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => productProvider.fetchProducts(),
                  child: GridView.builder(
                    padding: EdgeInsets.all(context.padding),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: context.gridColumns,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductCard(
                        product: product,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(
                                productId: product.id,
                              ),
                            ),
                          );
                        },
                        onWishlistTap: () {
                          productProvider.toggleWishlist(product.id);
                        },
                        isInWishlist: productProvider.isInWishlist(product.id),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filters',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Min Price',
                    isDense: true,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _minPrice = double.tryParse(value);
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Max Price',
                    isDense: true,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _maxPrice = double.tryParse(value);
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
