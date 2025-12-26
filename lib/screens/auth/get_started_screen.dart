import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // تحديد حالة الوضع المظلم لضمان تناسق الألوان مع باقي السلسلة
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: CircleAvatar(
            // توحيد تصميم زر الرجوع مع السواد العميق
            backgroundColor: isDark ? const Color(0xFF222222) : const Color(0xFFF5F6FA),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black, size: 20),
              // الرجوع من GetStarted -> Intro حسب المخطط
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              "Let's Get Started", 
              style: TextStyle(
                fontSize: 28, 
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF1D1E20),
              )
            ),
            const Spacer(),
            _socialBtn("Facebook", const Color(0xFF4267B2), Icons.facebook),
            _socialBtn("Twitter", const Color(0xFF1DA1F2), Icons.flutter_dash),
            _socialBtn("Google", const Color(0xFFEA4335), Icons.g_mobiledata),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account? ",
                  style: TextStyle(color: Color(0xFF8F959E), fontSize: 15),
                ),
                GestureDetector(
                  // الانتقال من GetStarted -> Login حسب المخطط
                  onTap: () => Navigator.pushNamed(context, '/login'), 
                  child: Text(
                    "Signin",
                    style: TextStyle(
                      fontWeight: FontWeight.w600, 
                      color: isDark ? Colors.white : Colors.black, 
                      fontSize: 15
                    )
                  )
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                // الانتقال من GetStarted -> Signup حسب المخطط
                onPressed: () => Navigator.pushNamed(context, '/signup'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9775FA),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  "Create an Account", 
                  style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialBtn(String text, Color color, IconData icon) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.only(bottom: 15),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon, color: Colors.white, size: 20),
        label: Text(
          text, 
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color, 
          foregroundColor: Colors.white, 
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}