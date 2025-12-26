import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/favorites_provider.dart';
import '../../services/api_service.dart';
import '../../models/product.dart';
import '../../widgets/product_card.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  bool _isEditing = false; 

  @override
  Widget build(BuildContext context) {
    // جلب البيانات من الـ Provider المرتبط بـ Firebase
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favoriteIds = favoritesProvider.favoriteIds;
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
              icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        title: Text(
          "Wishlist", 
          style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 17)
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: CircleAvatar(
              backgroundColor: isDark ? const Color(0xFF222222) : const Color(0xFFF5F6FA),
              child: IconButton(
                icon: Icon(Icons.shopping_bag_outlined, color: isDark ? Colors.white : Colors.black),
                onPressed: () => Navigator.pushNamed(context, '/cart'),
              ),
            ),
          )
        ],
      ),
      body: favoriteIds.isEmpty 
          ? _buildEmptyWishlist(isDark) 
          : _buildWishlistContent(context, favoriteIds, favoritesProvider, isDark),
    );
  }

  Widget _buildEmptyWishlist(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: isDark ? Colors.white10 : Colors.grey[300]),
          const SizedBox(height: 15),
          Text(
            "Your Wishlist is Empty", 
            style: TextStyle(color: isDark ? Colors.white70 : const Color(0xFF8F959E), fontSize: 16, fontWeight: FontWeight.w500)
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistContent(BuildContext context, List<String> favoriteIds, FavoritesProvider provider, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${favoriteIds.length} Items",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1D1E20)),
                  ),
                  const Text("in wishlist", style: TextStyle(fontSize: 15, color: Color(0xFF8F959E))),
                ],
              ),
              GestureDetector(
                onTap: () => setState(() => _isEditing = !_isEditing),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color: _isEditing ? const Color(0xFF9775FA).withOpacity(0.1) : (isDark ? const Color(0xFF222222) : const Color(0xFFF5F6FA)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(_isEditing ? Icons.check : Icons.edit_outlined, size: 16, color: _isEditing ? const Color(0xFF9775FA) : (isDark ? Colors.white : const Color(0xFF1D1E20))),
                      const SizedBox(width: 5),
                      Text(_isEditing ? "Done" : "Edit", style: TextStyle(fontWeight: FontWeight.bold, color: _isEditing ? const Color(0xFF9775FA) : (isDark ? Colors.white : const Color(0xFF1D1E20)))),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // جلب المنتجات من الـ API وتصفيتها بناءً على ما هو موجود في Firestore
          FutureBuilder<List<Product>>(
            future: ApiService().fetchProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF9775FA)));
              }
              
              final products = snapshot.data ?? [];
              final favProducts = products.where((p) => favoriteIds.contains(p.id.toString())).toList();

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.62,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: favProducts.length,
                itemBuilder: (context, index) {
                  final product = favProducts[index];
                  return Stack(
                    children: [
                      ProductCard(product: product),
                      if (_isEditing)
                        Positioned(
                          top: 5,
                          left: 5,
                          child: GestureDetector(
                            onTap: () => provider.toggleFavorite(product.id.toString()),
                            child: const CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.red,
                              child: Icon(Icons.close, size: 14, color: Colors.white),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}