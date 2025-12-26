import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../../providers/cart_provider.dart'; // تم الربط مع الـ CartProvider
import '../../providers/favorites_provider.dart'; // تم الربط مع الـ FavoritesProvider
import '../../widgets/custom_button.dart';

class ProductDetailsScreen extends StatefulWidget {
  final dynamic product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String _selectedSize = 'S';
  final List<String> _sizes = ['S', 'M', 'L', 'XL', '2XL'];

  // تنظيف الروابط القادمة من API خارجي لضمان عرض الصور
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    // استقبال المنتج سواء من الـ constructor أو من الـ Navigator arguments
    final p = widget.product ?? ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String productId = p['id'].toString();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 450,
                  width: double.infinity,
                  color: isDark ? const Color(0xFF222222) : const Color(0xFFF5F6FA),
                  child: Image.network(
                    cleanImageUrl(p['images'][0]), 
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 50, left: 20,
                  child: CircleAvatar(
                    backgroundColor: isDark ? const Color(0xFF292B2E) : Colors.white,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black), 
                      onPressed: () => Navigator.pop(context)
                    ),
                  ),
                ),
                // زر المفضلة المرتبط بـ Firebase
                Positioned(
                  top: 50, right: 20,
                  child: CircleAvatar(
                    backgroundColor: isDark ? const Color(0xFF292B2E) : Colors.white,
                    child: Consumer<FavoritesProvider>(
                      builder: (context, favProvider, child) {
                        bool isFav = favProvider.isFavorite(productId);
                        return IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : (isDark ? Colors.white : Colors.black),
                          ),
                          onPressed: () => favProvider.toggleFavorite(productId),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          p['title'], 
                          style: TextStyle(
                            fontSize: 22, 
                            fontWeight: FontWeight.w700, 
                            color: isDark ? Colors.white : const Color(0xFF1D1E20)
                          )
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text("Price", style: TextStyle(color: Color(0xFF8F959E), fontSize: 13)),
                          Text(
                            "\$${p['price']}", 
                            style: TextStyle(
                              fontSize: 22, 
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : Colors.black
                            )
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // معرض الصور المصغر
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: p['images'].length,
                      itemBuilder: (context, index) => Container(
                        width: 80,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF222222) : const Color(0xFFF5F6FA),
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(cleanImageUrl(p['images'][index])),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Size", 
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: isDark ? Colors.white : Colors.black)
                      ),
                      TextButton(onPressed: () {}, child: const Text("Size Guide", style: TextStyle(color: Color(0xFF8F959E)))),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _sizes.map((s) => _buildSizeBtn(s, isDark)).toList(),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    "Description", 
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: isDark ? Colors.white : Colors.black)
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Color(0xFF8F959E), height: 1.5, fontSize: 15),
                      children: [
                        TextSpan(text: p['description']),
                        TextSpan(
                          text: " Read More..", 
                          style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Reviews", 
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: isDark ? Colors.white : Colors.black)
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/reviews'), 
                        child: const Text("View All", style: TextStyle(color: Color(0xFF8F959E)))
                      ),
                    ],
                  ),
                  _buildReviewPreview(isDark),
                  const SizedBox(height: 150), 
                ],
              ),
            ),
          ],
        ),
      ),
      // الجزء السفلي الذي يحتوي على السعر النهائي وزر الإضافة للسلة
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF222222) : Colors.white,
          boxShadow: [if(!isDark) const BoxShadow(color: Colors.black12, blurRadius: 10)]
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Price", 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black)
                    ), 
                    const Text("with VAT,SD", style: TextStyle(color: Color(0xFF8F959E), fontSize: 11)),
                  ],
                ),
                Text(
                  "\$${(p['price'] as num) + 5}", 
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: isDark ? Colors.white : Colors.black)
                ),
              ],
            ),
            const SizedBox(height: 15),
            // زر الإضافة للسلة المرتبط بـ Firebase
            CustomButton(
              text: "Add to Cart", 
              onPressed: () {
                context.read<CartProvider>().addToCart(
                  productId,
                  p['title'],
                  (p['price'] as num).toDouble(),
                  cleanImageUrl(p['images'][0]),
                  _selectedSize,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Added to Bag! Syncing with Cloud..."),
                    duration: Duration(seconds: 1),
                  )
                );
              }
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewPreview(bool isDark) {
    return Row(
      children: [
        const CircleAvatar(radius: 20, backgroundImage: NetworkImage('https://via.placeholder.com/50')),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ronald Richards", 
              style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)
            ),
            Row(
              children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.amber, size: 12)),
            ),
          ],
        ),
        const Spacer(),
        Text(
          "4.8 rating", 
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.black)
        ),
      ],
    );
  }

  Widget _buildSizeBtn(String size, bool isDark) {
    bool isSelected = _selectedSize == size;
    return GestureDetector(
      onTap: () => setState(() => _selectedSize = size),
      child: Container(
        width: 60, height: 60,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF9775FA) : (isDark ? const Color(0xFF222222) : const Color(0xFFF5F6FA)),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          size, 
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            color: isSelected ? Colors.white : (isDark ? Colors.white : Colors.black)
          )
        ),
      ),
    );
  }
}