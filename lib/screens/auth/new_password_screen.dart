import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/custom_button.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _passController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;

  // دالة تحديث كلمة المرور مباشرة في Firebase
  Future<void> _handleFirebaseUpdate() async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    if (_passController.text.isEmpty || _passController.text != _confirmController.text) {
      messenger.showSnackBar(const SnackBar(content: Text("Passwords do not match!")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // الحصول على الجلسة النشطة للمستخدم
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // تنفيذ التحديث في سيرفرات Firebase
        await user.updatePassword(_passController.text.trim());
        
        messenger.showSnackBar(const SnackBar(content: Text("Password updated successfully in Firebase!")));
        
        // العودة لشاشة الـ Login ومسح السجل
        navigator.pushNamedAndRemoveUntil('/login', (route) => false);
      } else {
        messenger.showSnackBar(const SnackBar(content: Text("Error: No active user. Please login first.")));
      }
    } on FirebaseAuthException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text("Firebase Error: ${e.message}")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _passController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text("New Password", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: isDark ? Colors.white : Colors.black)),
            const SizedBox(height: 60),
            _buildInputField("Password", _passController, isDark),
            const SizedBox(height: 20),
            _buildInputField("Confirm Password", _confirmController, isDark),
            const Spacer(),
            const Text("Your password will be updated directly in your Firebase account.", textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF8F959E))),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        child: CustomButton(
          text: _isLoading ? "Updating..." : "Reset Password", 
          onPressed: _isLoading ? () {} : _handleFirebaseUpdate,
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF8F959E), fontSize: 13)),
        TextField(
          controller: controller,
          obscureText: true,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFE7E8EA))),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF9775FA))),
          ),
        ),
      ],
    );
  }
}