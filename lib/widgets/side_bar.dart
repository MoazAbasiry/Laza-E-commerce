import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class CustomSideBar extends StatefulWidget {
  const CustomSideBar({super.key});

  @override
  State<CustomSideBar> createState() => _CustomSideBarState();
}

class _CustomSideBarState extends State<CustomSideBar> {
  String _userName = "User"; // قيمة افتراضية

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // جلب اسم المستخدم عند فتح القائمة
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // جلب الاسم من جدول users بناءً على UID المستخدم المسجل في Firebase
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        setState(() {
          _userName = doc.data()!['username'] ?? "User";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDark = themeProvider.themeMode == ThemeMode.dark;

    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, 
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _userName, // عرض الاسم الحقيقي المجلوب من Firebase
                        style: TextStyle(
                          fontSize: 17, 
                          fontWeight: FontWeight.bold, 
                          color: Theme.of(context).textTheme.bodyLarge?.color 
                        ),
                      ),
                      const Row(
                        children: [
                          Text(
                            "Verified Profile",
                            style: TextStyle(fontSize: 11, color: Color(0xFF8F959E)),
                          ),
                          SizedBox(width: 5),
                          Icon(Icons.check_circle, size: 12, color: Color(0xFF48D861)),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF222222) : const Color(0xFFF5F6FA), 
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: const Text("3 Orders", style: TextStyle(fontSize: 11, color: Color(0xFF8F959E))),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  _buildMenuItem(
                    context, 
                    icon: Icons.wb_sunny_outlined, 
                    title: 'Dark Mode', 
                    trailing: Switch(
                      value: isDark,
                      onChanged: (val) => themeProvider.toggleTheme(val),
                      activeColor: const Color(0xFF48D861),
                    ),
                  ),
                  _buildMenuItem(context, icon: Icons.info_outline, title: 'Account Information', route: '/account-info'),
                  _buildMenuItem(context, icon: Icons.lock_outline, title: 'Password', route: '/password'),
                  _buildMenuItem(context, icon: Icons.shopping_bag_outlined, title: 'Order', route: '/orders'),
                  
                  // تم التعديل: تفعيل زر My Cards وربطه بمسار الصفحة
                  _buildMenuItem(
                    context, 
                    icon: Icons.credit_card_outlined, 
                    title: 'My Cards', 
                    route: '/my-cards' // ربط الزر بصفحة البطاقات
                  ),
                  
                  _buildMenuItem(context, icon: Icons.favorite_border, title: 'Wishlist', route: '/wishlist'),
                  _buildMenuItem(context, icon: Icons.settings_outlined, title: 'Settings', route: '/settings'),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: _buildMenuItem(
                context, 
                icon: Icons.logout, 
                title: 'Logout', 
                isLogout: true,
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  }
                }
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, {
    required IconData icon, 
    required String title, 
    String? route, 
    Widget? trailing,
    bool isLogout = false,
    VoidCallback? onTap,
  }) {
    final Color defaultColor = isLogout 
        ? const Color(0xFFEA4335) 
        : (Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF1D1E20));

    return ListTile(
      leading: Icon(icon, color: defaultColor),
      title: Text(
        title, 
        style: TextStyle(
          color: defaultColor, 
          fontWeight: FontWeight.w500,
          fontSize: 15
        )
      ),
      trailing: trailing,
      onTap: onTap ?? () {
        Navigator.pop(context); // إغلاق القائمة الجانبية أولاً
        if (route != null) Navigator.pushNamed(context, route); // التنقل للمسار المحدد
      },
    );
  }
}