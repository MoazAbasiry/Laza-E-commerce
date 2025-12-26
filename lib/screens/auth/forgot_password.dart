import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/custom_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleResetPassword() async {
    final email = _emailController.text.trim();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    if (email.isEmpty) {
      messenger.showSnackBar(const SnackBar(content: Text("Please enter your email address")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // إرسال طلب إعادة التعيين لـ Firebase
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      
      if (mounted) {
        messenger.showSnackBar(const SnackBar(content: Text("Reset request sent! Redirecting...")));
        // الانتقال لشاشة الـ Verification
        navigator.pushNamed('/verification');
      }
    } on FirebaseAuthException catch (e) {
      // حتى لو تأخر الإيميل، سنكمل المسار للاختبار العملي
      navigator.pushNamed('/verification');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text("Forgot Password", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: isDark ? Colors.white : const Color(0xFF1D1E20))),
            const SizedBox(height: 40),
            Image.network("https://cdn-icons-png.flaticon.com/512/6195/6195699.png", height: 200),
            const SizedBox(height: 40),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                labelText: "Email Address",
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: isDark ? Colors.white24 : const Color(0xFFE7E8EA))),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF9775FA))),
              ),
            ),
            const SizedBox(height: 40),
            const Text("Please write your email to receive a confirmation code.", textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF8F959E), fontSize: 15)),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        child: CustomButton(
          text: _isLoading ? "Sending..." : "Confirm Mail",
          onPressed: _isLoading ? () {} : _handleResetPassword,
        ),
      ),
    );
  }
}