import 'package:flutter/material.dart';

class ProfileDrawer extends StatefulWidget {
  const ProfileDrawer({super.key});

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  bool _isDarkMode = false; // محاكاة لـ toggleTheme

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 60),
            // الجزء العلوي: معلومات المستخدم
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage('https://picsum.photos/200'), // محاكاة لـ Avatar
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Mrh Raju", // مطابق للتصميم
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      Text(
                        "Verified Profile",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // عدد الطلبات
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text("3 Orders", style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // قائمة الخيارات
            _drawerItem(Icons.wb_sunny_outlined, "Dark Mode", 
              trailing: Switch(
                value: _isDarkMode,
                onChanged: (val) => setState(() => _isDarkMode = val),
                activeColor: const Color(0xFF9775FA),
              )
            ),
            _drawerItem(Icons.info_outline, "Account Information"),
            _drawerItem(Icons.lock_outline, "Password"),
            _drawerItem(Icons.shopping_bag_outlined, "Order"),
            _drawerItem(Icons.credit_card_outlined, "My Cards"),
            _drawerItem(Icons.favorite_border, "Wishlist", onTap: () {
              Navigator.pushNamed(context, '/wishlist');
            }),
            _drawerItem(Icons.settings_outlined, "Settings"),

            const Spacer(),

            // زر تسجيل الخروج
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ListTile(
                onTap: () {
                  // منطق الـ Logout
                  Navigator.pushReplacementNamed(context, '/login');
                },
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            
            // تذييل الصفحة الخاص بمشروع الجامعة
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                "Laza Team Project",
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, {Widget? trailing, VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Colors.black, size: 22),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
      ),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
    );
  }
}