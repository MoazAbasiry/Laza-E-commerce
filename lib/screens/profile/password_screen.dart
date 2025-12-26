import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/custom_button.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _updatePassword() async {
    final messenger = ScaffoldMessenger.of(context);

    if (_newPasswordController.text != _confirmPasswordController.text) {
      messenger.showSnackBar(const SnackBar(content: Text("New passwords do not match")));
      return;
    }

    if (_currentPasswordController.text.isEmpty) {
      messenger.showSnackBar(const SnackBar(content: Text("Please enter current password")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null && user.email != null) {
        // إعادة المصادقة (Re-authenticate) مطلوبة لتغيير كلمة المرور لأسباب أمنية
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: _currentPasswordController.text.trim(),
        );

        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(_newPasswordController.text.trim());

        if (mounted) {
          messenger.showSnackBar(const SnackBar(content: Text("Password updated successfully!")));
          Navigator.pop(context);
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = "Update failed";
      if (e.code == 'wrong-password') {
        message = "Current password is incorrect.";
      } else if (e.code == 'requires-recent-login') {
        message = "Please login again to perform this action.";
      }
      messenger.showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // التحقق من حالة الـ Dark Mode
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // جعل الخلفية تتغير حسب الثيم
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text("Password", 
          style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "You can update your password here to keep your account secure.",
              textAlign: TextAlign.center,
              style: TextStyle(color: isDark ? Colors.white70 : const Color(0xFF8F959E)),
            ),
            const SizedBox(height: 30),
            _buildPasswordField(_currentPasswordController, "Current Password", isDark),
            const SizedBox(height: 15),
            _buildPasswordField(_newPasswordController, "New Password", isDark),
            const SizedBox(height: 15),
            _buildPasswordField(_confirmPasswordController, "Confirm New Password", isDark),
          ],
        ),
      ),
      // إضافة زر التأكيد في الأسفل
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: CustomButton(
          text: _isLoading ? "UPDATING..." : "Update Password",
          onPressed: _isLoading ? () {} : _updatePassword,
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String hint, bool isDark) {
    return TextField(
      controller: controller,
      obscureText: true,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        // تعديل لون الحقل ليتناسب مع الـ Dark Mode
        fillColor: isDark ? const Color(0xFF222222) : const Color(0xFFF5F6FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}