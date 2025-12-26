import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // الوصول للمتحكم
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("ACCOUNT"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // رأس الصفحة
            Row(
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Moaz User",
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const Text("Verified Profile", style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 30),

            // زر الدارك مود
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.wb_sunny_outlined),
              title: const Text("Dark Mode", style: TextStyle(fontWeight: FontWeight.w500)),
              trailing: Switch(
                value: themeProvider.isDarkMode,
                activeColor: const Color(0xFF9775FA),
                onChanged: (value) {
                  // استدعاء التغيير
                  themeProvider.toggleTheme(value); 
                },
              ),
            ),

            _buildItem(context, Icons.info_outline, "Account Information"),
            _buildItem(context, Icons.lock_outline, "Password"),
            _buildItem(context, Icons.shopping_bag_outlined, "Order"),
            _buildItem(context, Icons.favorite_border, "Wishlist", route: '/wishlist'),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, IconData icon, String title, {String? route}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: route != null ? () => Navigator.pushNamed(context, route) : null,
    );
  }
}