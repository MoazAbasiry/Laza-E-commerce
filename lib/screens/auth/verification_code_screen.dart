import 'dart:async';
import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';

class VerificationCodeScreen extends StatefulWidget {
  const VerificationCodeScreen({super.key});

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  int _timerValue = 20;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerValue > 0) {
        if (mounted) setState(() => _timerValue--);
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _verifyOtp() {
    String code = _controllers.map((c) => c.text).join();
    // الكود الثابت للمحاكاة (Simulation) كما اتفقنا لإنهاء مسار الـ UI [cite: 13, 114]
    if (code == "1234") {
      Navigator.pushNamed(context, '/new-password');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid code! Try '1234' for testing.")),
      );
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
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: CircleAvatar(
            backgroundColor: isDark ? const Color(0xFF222222) : const Color(0xFFF5F6FA),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              "Verification Code", 
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: isDark ? Colors.white : const Color(0xFF1D1E20))
            ),
            const SizedBox(height: 40),
            Image.network(
              "https://cdn-icons-png.flaticon.com/512/6195/6195699.png", 
              height: 180, 
              color: isDark ? Colors.white.withOpacity(0.9) : null
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) => _otpBox(index, isDark)),
            ),
            const SizedBox(height: 60),
            Text(
              _timerValue > 0 ? "00:${_timerValue.toString().padLeft(2, '0')} resend code." : "Resend Code",
              style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.black)
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        child: CustomButton(text: "Confirm Code", onPressed: _verifyOtp),
      ),
    );
  }

  Widget _otpBox(int index, bool isDark) {
    return Container(
      width: 60, height: 80,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF222222) : Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isDark ? Colors.white10 : Colors.transparent)
      ),
      child: TextField(
        controller: _controllers[index],
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
        keyboardType: TextInputType.number,
        maxLength: 1,
        onChanged: (value) {
          if (value.length == 1 && index < 3) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
        },
        decoration: const InputDecoration(border: InputBorder.none, counterText: ""),
      ),
    );
  }
}