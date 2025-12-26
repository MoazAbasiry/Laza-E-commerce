import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/custom_button.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _ownerController = TextEditingController();
  final _numberController = TextEditingController();
  final _expController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _isLoading = false;

  // دالة حفظ البطاقة في Firebase
  Future<void> _saveCard() async {
    if (_ownerController.text.isEmpty || _numberController.text.isEmpty || 
        _expController.text.isEmpty || _cvvController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final String uid = FirebaseAuth.instance.currentUser?.uid ?? "";
      
      // الحفظ في مسار: users -> {uid} -> cards
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('cards')
          .add({
        'cardOwner': _ownerController.text.trim(),
        'cardNumber': _numberController.text.trim(),
        'exp': _expController.text.trim(),
        'cvv': _cvvController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        // العودة لشاشة My Cards حسب تسلسل المخطط
        Navigator.pop(context); 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Card added successfully!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Add New Card", 
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black, 
            fontWeight: FontWeight.bold
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: CircleAvatar(
            // توحيد تصميم زر الرجوع
            backgroundColor: isDark ? const Color(0xFF222222) : const Color(0xFFF5F6FA),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // أيقونات أنواع الدفع المطابقة للتصميم
            _buildPaymentMethodsRow(isDark),
            
            const SizedBox(height: 30),
            
            _buildLabel("Card Owner", isDark),
            _buildInputField(_ownerController, "Mrh Raju", isDark),
            
            const SizedBox(height: 20),
            
            _buildLabel("Card Number", isDark),
            _buildInputField(_numberController, "5254 7634 8734 7690", isDark, keyboard: TextInputType.number),
            
            const SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("EXP", isDark),
                      _buildInputField(_expController, "24/24", isDark),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("CVV", isDark),
                      _buildInputField(_cvvController, "7763", isDark, keyboard: TextInputType.number),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // خيار حفظ البطاقة كما في Screen 14
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Save card info", 
                  style: TextStyle(
                    fontSize: 15, 
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.black
                  )
                ),
                Switch(
                  value: true, 
                  onChanged: (val) {},
                  activeColor: const Color(0xFF48D861),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.all(20),
        child: CustomButton(
          text: _isLoading ? "SAVING..." : "Add Card",
          onPressed: _isLoading ? () {} : _saveCard,
        ),
      ),
    );
  }

  Widget _buildLabel(String text, bool isDark) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text, 
      style: TextStyle(
        fontWeight: FontWeight.bold, 
        fontSize: 16,
        color: isDark ? Colors.white : Colors.black
      )
    ),
  );

  Widget _buildInputField(TextEditingController controller, String hint, bool isDark, {TextInputType keyboard = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF222222) : const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildPaymentMethodsRow(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _paymentIcon("https://cdn-icons-png.flaticon.com/512/196/196082.png", true, isDark), 
        _paymentIcon("https://cdn-icons-png.flaticon.com/512/174/174861.png", false, isDark), 
        _paymentIcon("https://cdn-icons-png.flaticon.com/512/2830/2830284.png", false, isDark), 
      ],
    );
  }

  Widget _paymentIcon(String url, bool isSelected, bool isDark) {
    return Container(
      width: 100, height: 50,
      decoration: BoxDecoration(
        color: isSelected 
            ? (isDark ? const Color(0xFF2D2E33) : const Color(0xFFFFEBEA))
            : (isDark ? const Color(0xFF222222) : const Color(0xFFF5F6FA)),
        borderRadius: BorderRadius.circular(10),
        border: isSelected ? Border.all(color: const Color(0xFFFF5757)) : null,
      ),
      child: Image.network(url, scale: 15),
    );
  }
}