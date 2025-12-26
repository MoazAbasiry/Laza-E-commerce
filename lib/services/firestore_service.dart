import 'package:cloud_firestore/cloud_firestore.dart';
// تأكد من استيراد الـ Model الخاص بك هنا إذا كان لديك ملف note.dart

class FirestoreService {
  // 1. تعريف الـ Instance (الأساس)
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 2. اسم الـ Collection
  final String _collectionName = 'notes'; 

  // 3. الـ Getter للوصول السريع للـ Collection (التبعية)
  CollectionReference get _notesCollection => 
      _firestore.collection(_collectionName);

  // --- وظيفة الـ READ (قراءة البيانات) ---
  Stream<List<Map<String, dynamic>>> getNotes() {
    return _notesCollection
        .orderBy('updatedAt', descending: true) // الترتيب حسب الأحدث
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
    });
  }

  // --- وظيفة الـ CREATE (إضافة بيانات) ---
  Future<void> addNote(Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp(); // توقيت السيرفر
      await _notesCollection.add(data);
    } catch (e) {
      print("Error adding document: $e");
      rethrow;
    }
  }

  // --- وظيفة الـ UPDATE (تعديل بيانات) ---
  Future<void> updateNote(String docId, Map<String, dynamic> newData) async {
    try {
      newData['updatedAt'] = FieldValue.serverTimestamp();
      await _notesCollection.doc(docId).update(newData);
    } catch (e) {
      print("Error updating document: $e");
      rethrow;
    }
  }

  // --- وظيفة الـ DELETE (حذف بيانات) ---
  Future<void> deleteNote(String docId) async {
    try {
      await _notesCollection.doc(docId).delete();
    } catch (e) {
      print("Error deleting document: $e");
      rethrow;
    }
  }
}