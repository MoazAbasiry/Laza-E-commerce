import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';

class ReviewProvider with ChangeNotifier {
  List<ReviewModel> _reviews = [];
  bool _isLoading = false;

  List<ReviewModel> get reviews => _reviews;
  bool get isLoading => _isLoading;

  // دالة جلب التقييمات لمنتج معين
  Future<void> fetchProductReviews(String productId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('productId', isEqualTo: productId)
          .orderBy('date', descending: true)
          .get();

      _reviews = snapshot.docs
          .map((doc) => ReviewModel.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      debugPrint("Fetch Reviews Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // دالة إضافة تقييم جديد
  Future<void> addReview(ReviewModel review) async {
    try {
      await FirebaseFirestore.instance.collection('reviews').add(review.toMap());
      _reviews.insert(0, review);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}