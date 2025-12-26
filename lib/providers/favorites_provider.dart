import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesProvider with ChangeNotifier {
  List<String> _favoriteIds = [];

  List<String> get favoriteIds => _favoriteIds;

  bool isFavorite(String productId) => _favoriteIds.contains(productId);

  // 1. دالة جلب المفضلات عند فتح التطبيق
  Future<void> fetchFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();
      if (snapshot.exists && snapshot.data() != null && snapshot.data()!['favorites'] != null) {
        // تحويل البيانات القادمة من Firebase إلى قائمة نصوص
        _favoriteIds = List<String>.from(snapshot.data()!['favorites']);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error fetching favorites: $e");
    }
  }

  // 2. دالة تبديل حالة المفضلة (إضافة/حذف) ومزامنتها
  Future<void> toggleFavorite(String productId) async {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    notifyListeners();
    
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // تحديث الحقل في Firestore
        await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
          'favorites': _favoriteIds,
        }, SetOptions(merge: true));
      } catch (e) {
        debugPrint("Error updating favorites: $e");
      }
    }
  }
}