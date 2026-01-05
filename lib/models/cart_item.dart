import 'product.dart';

class CartItem {
  final Product product;
  int quantity;
  final Map<String, String>? selectedVariants; // e.g., {"Color": "Red", "Size": "M"}

  CartItem({
    required this.product,
    this.quantity = 1,
    this.selectedVariants,
  });

  double get totalPrice => product.finalPrice * quantity;

  String get variantString {
    if (selectedVariants == null || selectedVariants!.isEmpty) return '';
    return selectedVariants!.entries
        .map((e) => '${e.key}: ${e.value}')
        .join(', ');
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'] ?? 1,
      selectedVariants: json['selected_variants'] != null
          ? Map<String, String>.from(json['selected_variants'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'selected_variants': selectedVariants,
    };
  }

  // Helper method to check if two cart items are the same
  bool isSameProduct(CartItem other) {
    if (product.id != other.product.id) return false;
    if (selectedVariants == null && other.selectedVariants == null) return true;
    if (selectedVariants == null || other.selectedVariants == null) return false;
    
    if (selectedVariants!.length != other.selectedVariants!.length) return false;
    
    for (var key in selectedVariants!.keys) {
      if (selectedVariants![key] != other.selectedVariants![key]) return false;
    }
    
    return true;
  }
}
