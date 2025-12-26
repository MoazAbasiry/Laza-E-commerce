import 'package:flutter/material.dart';
import '../../widgets/product_card.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // التحقق من حالة الوضع المظلم الحالية
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    // محاكاة بيانات Favorites (سيتم ربطها بـ Provider لاحقاً)
    final List<dynamic> favorites = []; 

    return Scaffold(
      // تم التعديل: جعل الخلفية تتبع الثيم المختار
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          "WISHLIST", 
          style: TextStyle(
            fontWeight: FontWeight.w900,
            // تغيير لون النص بناءً على الثيم
            color: isDark ? Colors.white : Colors.black
          )
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: CircleAvatar(
            // تغيير لون أيقونة الرجوع وخلفيتها لتناسب الوضع المظلم
            backgroundColor: isDark ? const Color(0xFF222222) : const Color(0xFFF5F6FA),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ),
      body: favorites.isEmpty 
        ? _buildEmptyWishlist(context, isDark)
        : GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, 
              childAspectRatio: 0.65, 
              crossAxisSpacing: 15, 
              mainAxisSpacing: 15
            ),
            itemCount: favorites.length,
            // كروت المنتجات أصبحت تدعم الـ Dark Mode بالفعل بعد تعديلنا السابق لها
            itemBuilder: (context, index) => ProductCard(product: favorites[index]),
          ),
    );
  }

  Widget _buildEmptyWishlist(BuildContext context, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // تعديل ألوان الأيقونة والنصوص في الحالة الفارغة
          Icon(
            Icons.favorite_border, 
            size: 100, 
            color: isDark ? const Color(0xFF222222) : Colors.grey[300]
          ),
          const SizedBox(height: 20),
          Text(
            "Your wishlist is lonely.", 
            style: TextStyle(
              fontSize: 18, 
              color: isDark ? Colors.white70 : Colors.grey, 
              fontWeight: FontWeight.bold
            )
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9775FA), 
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text("Explore Trends", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}