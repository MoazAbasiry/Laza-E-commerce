import 'cart_item.dart';

class OrderModel {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderModel({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });

  // تحويل البيانات لـ Map لحفظها في Firestore
  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'dateTime': dateTime.toIso8601String(),
      'products': products.map((cp) => cp.toMap()).toList(),
    };
  }
}