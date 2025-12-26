import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart'; 
import '../../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;

  void _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      // تنفيذ تسجيل الدخول عبر Firebase Auth [cite: 17, 41, 42]
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      
      if (mounted) {
        // الانتقال للهوم ومسح السجل لضمان عدم العودة للوجن بالخطأ [cite: 10, 116]
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      String message = "Login failed";
      if (e.code == 'user-not-found') message = "No user found for that email.";
      else if (e.code == 'wrong-password') message = "Wrong password provided.";
      
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
            backgroundColor: isDark ? const Color(0xFF222222) : const Color(0xFFF5F6FA),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
              onPressed: () {
                // منع الشاشة السوداء عبر العودة للـ Signup أو GetStarted 
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  Navigator.pushReplacementNamed(context, '/signup');
                }
              },
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
                "Welcome", 
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.w900, 
                  color: isDark ? Colors.white : const Color(0xFF1D1E20)
                )
              ),
              const Text(
                "Please enter your data to continue", 
                style: TextStyle(color: Color(0xFF8F959E), fontSize: 15, fontWeight: FontWeight.w400)
              ),
              const SizedBox(height: 50),
              _buildInputField("Email Address", _emailController, false, true, isDark),
              const SizedBox(height: 20),
              _buildInputField("Password", _passwordController, true, false, isDark),
              
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
                  child: const Text(
                    "Forgot password?", 
                    style: TextStyle(color: Color(0xFFEA4335), fontSize: 14)
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Remember me",
                    style: TextStyle(
                      fontSize: 15, 
                      fontWeight: FontWeight.w500, 
                      color: isDark ? Colors.white : const Color(0xFF1D1E20)
                    ),
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      value: _rememberMe,
                      activeColor: const Color(0xFF48D861), 
                      onChanged: (val) => setState(() => _rememberMe = val),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              
              const Text(
                "By connecting your account confirm that you agree with our Term and Condition",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Color(0xFF8F959E), height: 1.5),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.all(20),
        child: CustomButton(
          text: _isLoading ? "LOGGING IN..." : "Login",
          onPressed: _isLoading ? () {} : _handleLogin,
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, bool isPassword, bool showCheck, bool isDark) {
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
            suffixIcon: showCheck 
              ? const Icon(Icons.check, color: Color(0xFF48D861), size: 20)
              : isPassword 
                ? const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text("Strong", style: TextStyle(color: Color(0xFF48D861), fontSize: 11)),
                  )
                : null,
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFE7E8EA))),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF9775FA))),
          ),
        ),
      ],
    );
  }
}