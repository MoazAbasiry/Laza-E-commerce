class CartItem {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  int quantity;
  final String size;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
    required this.size,
  });

  // 1. تحويل البيانات لـ Map لحفظها في Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'size': size,
    };
  }

  // 2. الدالة التي كانت ناقصة: تحويل البيانات القادمة من Firestore إلى كائن CartItem
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      // التأكد من تحويل الرقم لـ double بشكل آمن
      price: (map['price'] as num).toDouble(), 
      imageUrl: map['imageUrl'] ?? '',
      quantity: map['quantity'] ?? 1,
      size: map['size'] ?? '',
    );
  }
}