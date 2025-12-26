import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({super.key});

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  String _username = "";
  String _email = "";
  String _phone = "+20 123 456 789"; // قيمة افتراضية حتى تضاف في Firestore
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print("Fetching data for UID: ${user.uid}"); // رسالة للتأكد من الـ UID

        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          print("Data received: $data"); // ستظهر لك في الـ Console البيانات الحقيقية

          setState(() {
            // التأكد من مطابقة أسماء الحقول لما في الصورة 
            _username = data['username'] ?? "No Username found";
            _email = data['email'] ?? user.email ?? "No Email found";
            _isLoading = false;
          });
        } else {
          print("Document does not exist in Firestore!");
          setState(() {
            _username = "User Not Found";
            _email = user.email ?? "Not Found";
            _isLoading = false;
          });
        }
      } else {
        print("No user is currently logged in.");
      }
    } catch (e) {
      print("Error fetching account info: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Account Information"),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF9775FA))) // مؤشر تحميل [cite: 87]
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildInfoTile(context, "Username", _username, isDark),
                  _buildInfoTile(context, "Email", _email, isDark),
                  _buildInfoTile(context, "Phone", _phone, isDark),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoTile(BuildContext context, String label, String value, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF222222) : const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF8F959E), fontSize: 14)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}