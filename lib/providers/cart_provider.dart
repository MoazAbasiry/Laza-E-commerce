import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, item) => total += item.price * item.quantity);
    return total;
  }

  // 1. دالة جلب السلة من Firebase عند بداية تشغيل التطبيق
  Future<void> fetchCartItems() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();
      if (snapshot.exists && snapshot.data() != null && snapshot.data()!['cart'] != null) {
        final cartData = snapshot.data()!['cart'] as Map<String, dynamic>;
        final Map<String, CartItem> loadedItems = {};
        
        cartData.forEach((key, value) {
          loadedItems[key] = CartItem.fromMap(value as Map<String, dynamic>);
        });
        
        _items = loadedItems;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error fetching cart: $e");
    }
  }

  Future<void> addToCart(String productId, String title, double price, String image, String size) async {
    if (_items.containsKey(productId)) {
      _items.update(productId, (existing) => CartItem(
        id: existing.id, title: existing.title, price: existing.price,
        imageUrl: existing.imageUrl, size: existing.size, quantity: existing.quantity + 1
      ));
    } else {
      _items.putIfAbsent(productId, () => CartItem(
        id: productId, title: title, price: price, imageUrl: image, size: size, quantity: 1
      ));
    }
    notifyListeners();
    await _syncWithFirebase(); 
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
    _syncWithFirebase();
  }

  Future<void> removeSingleItem(String productId) async {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity > 1) {
      _items.update(productId, (existing) => CartItem(
        id: existing.id, title: existing.title, price: existing.price,
        imageUrl: existing.imageUrl, size: existing.size, quantity: existing.quantity - 1
      ));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
    await _syncWithFirebase();
  }

  // 2. دالة تفريغ السلة (تستخدم عند إتمام الطلب Checkout)
  Future<void> clearCart() async {
    _items = {};
    notifyListeners();
    await _syncWithFirebase();
  }

  // مزامنة البيانات مع Firestore
  Future<void> _syncWithFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cartData = _items.map((key, item) => MapEntry(key, item.toMap()));
      await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
        'cart': cartData,
      }, SetOptions(merge: true));
    }
  }
}