import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/favorites_provider.dart'; 

class ProductCard extends StatelessWidget {
  final Product product; 
  
  const ProductCard({super.key, required this.product});

  String cleanImageUrl(String url) {
    if (url.isEmpty) return 'https://via.placeholder.com/150';
    String clean = url.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '').trim();
    if (clean.startsWith("'") && clean.endsWith("'")) {
      clean = clean.substring(1, clean.length - 1);
    }
    return clean;
  }

  @override
  Widget build(BuildContext context) {
    final String productId = product.id.toString();
    // التحقق من حالة الثيم الحالية
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context, 
          '/product-details', 
          arguments: {
            'id': product.id,
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'images': product.images,
            'category': {
              'name': product.categoryName,
            },
          },
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 200, 
                width: double.infinity,
                decoration: BoxDecoration(
                  // تم التعديل: تغيير خلفية الكارت لتصبح أغمق في الـ Dark Mode
                  color: isDark ? const Color(0xFF222222) : const Color(0xFFF5F6FA),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    cleanImageUrl(product.images.isNotEmpty ? product.images[0] : ''),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Consumer<FavoritesProvider>(
                  builder: (context, favProvider, child) {
                    bool isFav = favProvider.isFavorite(productId);
                    return GestureDetector(
                      onTap: () => favProvider.toggleFavorite(productId),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? const Color(0xFFEA4335) : const Color(0xFF8F959E),
                        size: 22,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            product.title, 
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              // تم التعديل: تغيير لون النص ليصبح أبيض في الوضع المظلم
              color: isDark ? Colors.white : const Color(0xFF1D1E20),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "\$${product.price}", 
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              // تم التعديل: تغيير لون السعر ليصبح أبيض في الوضع المظلم
              color: isDark ? Colors.white : const Color(0xFF1D1E20),
            ),
          ),
        ],
      ),
    );
  }
}