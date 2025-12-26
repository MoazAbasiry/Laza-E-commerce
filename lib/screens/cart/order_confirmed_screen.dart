import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';

class OrderConfirmedScreen extends StatelessWidget {
  const OrderConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // التحقق من حالة الوضع المظلم
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // استخدام خلفية الثيم الديناميكية
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: CircleAvatar(
            // تعديل ألوان زر الرجوع لتناسب التصميم المظلم
            backgroundColor: isDark ? const Color(0xFF222222) : const Color(0xFFF5F6FA),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                "https://i.ibb.co/LzNfGkQ/order-confirmed.png", 
                height: 250,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.check_circle, size: 200, color: Color(0xFF9775FA)),
              ),
              const SizedBox(height: 40),
              Text(
                "Order Confirmed!", 
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.w700, 
                  // تغيير لون النص للأبيض في الدارك مود
                  color: isDark ? Colors.white : const Color(0xFF1D1E20)
                )
              ),
              const SizedBox(height: 15),
              const Text(
                "Your order has been confirmed, we will send you confirmation email shortly.", 
                textAlign: TextAlign.center, 
                style: TextStyle(color: Color(0xFF8F959E), fontSize: 15, height: 1.4)
              ),
              const SizedBox(height: 80), 
              
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/orders');
                  },
                  style: ElevatedButton.styleFrom(
                    // لون زر "Go to Orders" يصبح رمادي داكن في الدارك مود
                    backgroundColor: isDark ? const Color(0xFF222222) : const Color(0xFFF5F5F5), 
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    "Go to Orders", 
                    style: TextStyle(color: Color(0xFF8F959E), fontWeight: FontWeight.w500, fontSize: 17)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        // تعديل لون شريط التنقل السفلي
        color: Theme.of(context).scaffoldBackgroundColor,
        child: CustomButton(
          text: "Continue Shopping", 
          onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false),
        ),
      ),
    );
  }
}