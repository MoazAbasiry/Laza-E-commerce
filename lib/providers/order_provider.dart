import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/order_model.dart';
import '../models/cart_item.dart';

class OrderProvider with ChangeNotifier {
  List<OrderModel> _orders = [];
  List<OrderModel> get orders => [..._orders];

  // دالة جلب الطلبات من Firestore 
  Future<void> fetchOrders() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .orderBy('dateTime', descending: true) // عرض الأحدث أولاً
          .get();

      _orders = snapshot.docs.map((doc) {
        final data = doc.data();
        return OrderModel(
          id: doc.id,
          amount: (data['amount'] as num).toDouble(),
          dateTime: DateTime.parse(data['dateTime']),
          products: (data['products'] as List).map((item) => CartItem(
            id: item['id'],
            title: item['title'],
            price: (item['price'] as num).toDouble(),
            imageUrl: item['imageUrl'],
            quantity: item['quantity'],
            size: item['size'],
          )).toList(),
        );
      }).toList();
      
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching orders: $e");
    }
  }

  // دالة إضافة الطلب (التي استخدمناها سابقاً في السلة) [cite: 66]
  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final timestamp = DateTime.now();
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .add({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts.map((cp) => {
          'id': cp.id,
          'title': cp.title,
          'price': cp.price,
          'imageUrl': cp.imageUrl,
          'quantity': cp.quantity,
          'size': cp.size,
        }).toList(),
      });
      await fetchOrders(); // تحديث القائمة فوراً بعد الإضافة
    } catch (error) {
      rethrow;
    }
  }
}