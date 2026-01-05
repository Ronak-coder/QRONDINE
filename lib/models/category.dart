class Category {
  final String id;
  final String name;
  final String image;
  final String? icon;
  final int productCount;
  final List<Category>? subcategories;

  Category({
    required this.id,
    required this.name,
    required this.image,
    this.icon,
    this.productCount = 0,
    this.subcategories,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      icon: json['icon'],
      productCount: json['product_count'] ?? 0,
      subcategories: json['subcategories'] != null
          ? (json['subcategories'] as List)
              .map((c) => Category.fromJson(c))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'icon': icon,
      'product_count': productCount,
      'subcategories': subcategories?.map((c) => c.toJson()).toList(),
    };
  }
}
