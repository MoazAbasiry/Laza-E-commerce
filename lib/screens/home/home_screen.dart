import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:provider/provider.dart'; 
import '../../providers/cart_provider.dart'; 
import '../../providers/favorites_provider.dart'; 
import '../../providers/card_provider.dart'; // إضافة موفر البطاقات
import '../../providers/address_provider.dart'; // إضافة موفر العناوين
import '../../services/api_service.dart';
import '../../widgets/product_card.dart';
import '../../widgets/side_bar.dart';
import '../../models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ApiService _apiService = ApiService();
  
  String _searchQuery = '';
  String? _selectedBrand;
  int _currentIndex = 0; 
  String _userName = "User"; 

  @override
  void initState() {
    super.initState();
    _fetchUserData(); 
    
    // جلب كافة بيانات المستخدم من Firestore عند بداية تشغيل الشاشة لضمان استمراريتها [cite: 23, 64]
    Future.delayed(Duration.zero, () {
      if (mounted) {
        Provider.of<CartProvider>(context, listen: false).fetchCartItems();
        Provider.of<FavoritesProvider>(context, listen: false).fetchFavorites();
        Provider.of<CardProvider>(context, listen: false).fetchCards(); // جلب البطاقات المحفوظة
        Provider.of<AddressProvider>(context, listen: false).fetchAddresses(); // جلب العناوين المحفوظة
      }
    });
  }

  Future<void> _fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists && doc.data() != null) {
          setState(() {
            _userName = doc.data()!['username'] ?? "User"; 
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    }
  }

  final List<Map<String, String>> _brands = [
    {'name': 'Adidas', 'logo': 'https://cdn-icons-png.flaticon.com/512/731/731962.png'},
    {'name': 'Nike', 'logo': 'https://cdn-icons-png.flaticon.com/512/732/732229.png'},
    {'name': 'Fila', 'logo': 'https://cdn-icons-png.flaticon.com/512/5968/5968313.png'},
    {'name': 'Puma', 'logo': 'https://cdn-icons-png.flaticon.com/512/882/882704.png'},
  ];

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false, 
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        drawer: const CustomSideBar(),
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: CircleAvatar(
              backgroundColor: isDark ? const Color(0xFF222222) : const Color(0xFFF5F6FA),
              child: IconButton(
                icon: Icon(Icons.sort, color: isDark ? Colors.white : Colors.black),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: isDark ? const Color(0xFF222222) : const Color(0xFFF5F6FA),
                    child: IconButton(
                      icon: Icon(Icons.shopping_bag_outlined, color: isDark ? Colors.white : Colors.black),
                      onPressed: () => Navigator.pushNamed(context, '/cart'),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Consumer<CartProvider>(
                      builder: (context, cart, child) => cart.itemCount > 0 
                        ? Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF5757),
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                            child: Text(
                              '${cart.itemCount}',
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : const SizedBox(),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                "Hello $_userName", 
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.w900, 
                  color: isDark ? Colors.white : const Color(0xFF1D1E20)
                )
              ),
              const Text(
                "Welcome to Laza.", 
                style: TextStyle(color: Color(0xFF8F959E), fontSize: 15, fontWeight: FontWeight.w400)
              ),
              const SizedBox(height: 25),
              
              _buildSearchField(isDark),
              const SizedBox(height: 25),
              
              _buildBrandsSection(isDark),
              
              const SizedBox(height: 25),
              
              _buildNewArrivalSection(isDark),
              
              const SizedBox(height: 15),
              
              _buildProductsGrid(),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNavBar(isDark),
      ),
    );
  }

  Widget _buildBrandsSection(bool isDark) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Choose Brand", 
              style: TextStyle(
                fontSize: 17, 
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : Colors.black
              )
            ),
            TextButton(
              onPressed: () {}, 
              child: const Text("View All", style: TextStyle(color: Color(0xFF8F959E)))
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildBrandsList(isDark),
      ],
    );
  }

  Widget _buildNewArrivalSection(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "New Arrival", 
          style: TextStyle(
            fontSize: 17, 
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Colors.black
          )
        ),
        TextButton(
          onPressed: () {}, 
          child: const Text("View All", style: TextStyle(color: Color(0xFF8F959E)))
        ),
      ],
    );
  }

  Widget _buildProductsGrid() {
    return FutureBuilder<List<Product>>(
      future: _apiService.fetchProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF9775FA)));
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Error loading products"));
        }

        List<Product> products = snapshot.data ?? [];
        List<Product> filtered = products.where((p) {
          final titleMatch = p.title.toLowerCase().contains(_searchQuery.toLowerCase());
          final brandMatch = _selectedBrand == null || 
                             p.title.toLowerCase().contains(_selectedBrand!.toLowerCase());
          return titleMatch && brandMatch;
        }).toList();

        return GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 20),
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, 
            childAspectRatio: 0.62,
            crossAxisSpacing: 15, 
            mainAxisSpacing: 15
          ),
          itemCount: filtered.length,
          itemBuilder: (context, index) => ProductCard(product: filtered[index]),
        );
      },
    );
  }

  Widget _buildBottomNavBar(bool isDark) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() => _currentIndex = index);
        if (index == 1) Navigator.pushNamed(context, '/wishlist');
        if (index == 2) Navigator.pushNamed(context, '/cart');
        if (index == 3) Navigator.pushNamed(context, '/my-cards');
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF9775FA),
      unselectedItemColor: const Color(0xFF8F959E),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: isDark ? const Color(0xFF222222) : Colors.white,
      elevation: 10,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Wishlist"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: "Cart"),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: "My Cards"),
      ],
    );
  }

  Widget _buildSearchField(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF222222) : const Color(0xFFF5F6FA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: const InputDecoration(
                hintText: "Search...",
                hintStyle: TextStyle(color: Color(0xFF8F959E)),
                prefixIcon: Icon(Icons.search, color: Color(0xFF8F959E)),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Container(
          height: 50, width: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF9775FA), 
            borderRadius: BorderRadius.circular(10)
          ),
          child: const Icon(Icons.mic_none, color: Colors.white),
        )
      ],
    );
  }

  Widget _buildBrandsList(bool isDark) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _brands.length,
        itemBuilder: (context, index) {
          final brand = _brands[index];
          bool isSelected = _selectedBrand == brand['name'];
          return GestureDetector(
            onTap: () => setState(() => _selectedBrand = isSelected ? null : brand['name']),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF222222) : const Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(10),
                border: isSelected ? Border.all(color: const Color(0xFF9775FA)) : null,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF292B2E) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.network(brand['logo']!, width: 20, fit: BoxFit.contain),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    brand['name']!, 
                    style: TextStyle(
                      fontWeight: FontWeight.w600, 
                      fontSize: 15,
                      color: isDark ? Colors.white : Colors.black
                    )
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}