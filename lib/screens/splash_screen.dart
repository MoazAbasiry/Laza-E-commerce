import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    // توقيت الانتقال (3 ثوانٍ) حسب المخطط
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        final user = FirebaseAuth.instance.currentUser;

        // فحص حالة المستخدم الحالية لضمان لوجيك الـ Remember Me
        if (user != null) {
          // إذا كان مسجلاً، يذهب للرئيسية مباشرة (Home)
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // البداية الصحيحة من الـ Intro حسب المخطط
          Navigator.pushReplacementNamed(context, '/intro');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // اللون البنفسجي الموحد من الـ UI Kit
      backgroundColor: const Color(0xFF9775FA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // كلمة laza بتنسيق مطابق للوغو الأصلي
            const Text(
              'laza',
              style: TextStyle(
                color: Colors.white,
                fontSize: 65, 
                fontWeight: FontWeight.w900,
                letterSpacing: -4, 
              ),
            ),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}