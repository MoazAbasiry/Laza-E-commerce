import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/address_model.dart';

class AddressProvider with ChangeNotifier {
  List<AddressModel> _addresses = [];
  List<AddressModel> get addresses => [..._addresses];

  // دالة إضافة عنوان جديد لـ Firestore [cite: 64, 65]
  Future<void> addAddress(String city, String street, String phone) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final response = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('addresses')
          .add({
        'city': city,
        'street': street,
        'phone': phone,
        'isDefault': _addresses.isEmpty, // أول عنوان يكون هو الافتراضي تلقائياً
      });

      _addresses.add(AddressModel(
        id: response.id,
        city: city,
        street: street,
        phone: phone,
        isDefault: _addresses.isEmpty,
      ));
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // دالة جلب العناوين عند فتح التطبيق [cite: 43, 64]
  Future<void> fetchAddresses() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('addresses')
          .get();
      
      _addresses = snapshot.docs.map((doc) => AddressModel.fromMap(doc.id, doc.data())).toList();
      notifyListeners();
    } catch (e) {
      debugPrint("Fetch Address Error: $e");
    }
  }
}