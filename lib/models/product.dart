class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? discountPrice;
  final List<String> images;
  final String categoryId;
  final String categoryName;
  final double rating;
  final int reviewCount;
  final int stock;
  final List<ProductVariant>? variants;
  final List<String>? tags;
  final bool isFeatured;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.images,
    required this.categoryId,
    required this.categoryName,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.stock = 0,
    this.variants,
    this.tags,
    this.isFeatured = false,
    required this.createdAt,
  });

  double get finalPrice => discountPrice ?? price;
  
  bool get hasDiscount => discountPrice != null && discountPrice! < price;
  
  int get discountPercentage {
    if (!hasDiscount) return 0;
    return (((price - discountPrice!) / price) * 100).round();
  }
  
  bool get isInStock => stock > 0;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discountPrice: json['discount_price'] != null 
          ? (json['discount_price'] as num).toDouble() 
          : null,
      images: List<String>.from(json['images'] ?? []),
      categoryId: json['category_id'] ?? '',
      categoryName: json['category_name'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      stock: json['stock'] ?? 0,
      variants: json['variants'] != null
          ? (json['variants'] as List)
              .map((v) => ProductVariant.fromJson(v))
              .toList()
          : null,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      isFeatured: json['is_featured'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'discount_price': discountPrice,
      'images': images,
      'category_id': categoryId,
      'category_name': categoryName,
      'rating': rating,
      'review_count': reviewCount,
      'stock': stock,
      'variants': variants?.map((v) => v.toJson()).toList(),
      'tags': tags,
      'is_featured': isFeatured,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class ProductVariant {
  final String name; // e.g., "Color", "Size"
  final List<String> options; // e.g., ["Red", "Blue"], ["S", "M", "L"]

  ProductVariant({
    required this.name,
    required this.options,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      name: json['name'] ?? '',
      options: List<String>.from(json['options'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'options': options,
    };
  }
}
