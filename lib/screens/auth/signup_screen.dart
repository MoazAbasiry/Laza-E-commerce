import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/custom_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleSignup() async {
    if (_usernameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    setState(() => _isLoading = true);
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // حفظ بيانات المستخدم في Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'username': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
        'uid': userCredential.user!.uid,
      });

      if (mounted) {
        // تم التعديل وفقاً للمخطط: بعد التسجيل، ننتقل لـ Login ليبدأ تسلسل العودة الصحيح
        Navigator.pushNamed(context, '/login');
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account created! Please login to continue."))
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
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
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: CircleAvatar(
            // الحفاظ على تصميم الوضع المظلم الموحد
            backgroundColor: isDark ? const Color(0xFF222222) : const Color(0xFFF5F6FA),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
              // الرجوع الطبيعي لشاشة GetStarted (أو Signin حسب التسمية في مخططك)
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                "Sign Up", 
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.w900, 
                  color: isDark ? Colors.white : const Color(0xFF1D1E20)
                )
              ),
              const SizedBox(height: 50),
              _buildInputField("Username", _usernameController, false, isDark),
              const SizedBox(height: 20),
              _buildInputField("Email Address", _emailController, false, isDark),
              const SizedBox(height: 20),
              _buildInputField("Password", _passwordController, true, isDark),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.all(20),
        child: CustomButton(
          text: _isLoading ? "SIGNING UP..." : "Sign Up",
          onPressed: _isLoading ? () {} : _handleSignup,
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, bool isPassword, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF8F959E), fontSize: 13, fontWeight: FontWeight.w500),
        ),
        TextField(
          controller: controller,
          obscureText: isPassword,
          style: TextStyle(
            fontWeight: FontWeight.w600, 
            fontSize: 15, 
            color: isDark ? Colors.white : Colors.black
          ),
          decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFE7E8EA))),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF9775FA))),
          ),
        ),
      ],
    );
  }
}