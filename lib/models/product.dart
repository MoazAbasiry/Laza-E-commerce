class Product {
  final String id;
  final String title;
  final double price;
  final String description;
  final List<String> images;
  final String categoryName;
  final String brand;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.images,
    required this.categoryName,
    required this.brand,
  });

  // 1. القراءة من Firestore (للمستقبل أو لو ضفت منتجات يدوية)
  factory Product.fromFirestore(Map<String, dynamic> json, String documentId) {
    return Product(
      id: documentId,
      title: json['title'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      categoryName: json['categoryName'] ?? 'General',
      brand: json['brand'] ?? 'General',
    );
  }

  // 2. القراءة من Fake Store API (الأساس اللي هيظهر المنتجات الـ 20)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      categoryName: json['category'] != null ? json['category']['name'] : 'General',
      brand: 'General', 
    );
  }
}