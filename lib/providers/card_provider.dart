import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/card_model.dart';

class CardProvider with ChangeNotifier {
  List<CardModel> _cards = [];
  List<CardModel> get cards => [..._cards];

  // دالة إضافة بطاقة جديدة 
  Future<void> addCard(String holder, String number, String expiry, String cvv) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final response = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cards')
          .add({
        'cardHolder': holder,
        'cardNumber': number,
        'expiryDate': expiry,
        'cvv': cvv,
      });

      _cards.add(CardModel(id: response.id, cardHolder: holder, cardNumber: number, expiryDate: expiry, cvv: cvv));
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // دالة جلب البطاقات عند فتح التطبيق [cite: 64]
  Future<void> fetchCards() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cards')
          .get();
      
      _cards = snapshot.docs.map((doc) => CardModel.fromMap(doc.id, doc.data())).toList();
      notifyListeners();
    } catch (e) {
      debugPrint("Fetch Cards Error: $e");
    }
  }
}