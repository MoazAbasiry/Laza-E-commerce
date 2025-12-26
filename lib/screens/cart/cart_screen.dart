import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart'; // تم إضافة الـ OrderProvider [cite: 76]
import '../../widgets/custom_button.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double get shipping => 10.0;

  // دالة إتمام الطلب المعدلة لربط الـ Orders مع Firebase [cite: 66, 76, 79]
  void _handleCheckout(CartProvider cart) async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    try {
      // 1. حفظ الطلب في Firestore أولاً قبل مسح السلة [cite: 23, 76]
      await orderProvider.addOrder(
        cart.items.values.toList(),
        cart.totalAmount + shipping,
      );

      // 2. تفريغ السلة برمجياً ومن الفايربيز بعد نجاح تسجيل الطلب [cite: 79]
      await cart.clearCart();

      // 3. الانتقال لشاشة نجاح الطلب [cite: 78]
      if (mounted) {
        Navigator.pushNamed(context, '/order-confirmed');
      }
    } catch (e) {
      // إظهار خطأ في حالة فشل الاتصال بقاعدة البيانات
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to process order. Please try again.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          "Cart",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: CircleAvatar(
            backgroundColor: isDark ? const Color(0xFF222222) : const Color(0xFFF5F6FA),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: cart.items.isEmpty ? _emptyCart(isDark) : _cartList(cart, isDark),
      bottomNavigationBar: cart.items.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF222222) : Colors.white,
                boxShadow: [if (!isDark) const BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: CustomButton(
                text: "Checkout",
                onPressed: () => _handleCheckout(cart),
              ),
            ),
    );
  }

  Widget _emptyCart(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: isDark ? Colors.white12 : Colors.grey[200]),
          const SizedBox(height: 20),
          Text(
            "Your bag is empty.",
            style: TextStyle(
              fontSize: 18,
              color: isDark ? Colors.white70 : const Color(0xFF8F959E),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9775FA), shape: const StadiumBorder()),
            onPressed: () => Navigator.pushNamed(context, '/home'),
            child: const Text("Browse Trends", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  Widget _cartList(CartProvider cart, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          ...cart.items.entries.map((entry) => _cartItemTile(entry.key, entry.value, cart, isDark)),
          const SizedBox(height: 25),
          _addressPreview(isDark),
          const SizedBox(height: 15),
          _paymentPreview(isDark),
          const SizedBox(height: 25),
          _orderInfo(cart, isDark),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _cartItemTile(String productId, dynamic item, CartProvider cart, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF222222) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(item.imageUrl, width: 80, height: 100, fit: BoxFit.cover),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 2,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "\$${item.price.toStringAsFixed(2)} (Tax Included)",
                  style: const TextStyle(color: Color(0xFF8F959E), fontSize: 11),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _qtyBtn(Icons.keyboard_arrow_down, () => cart.removeSingleItem(productId), isDark),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "${item.quantity}",
                        style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
                      ),
                    ),
                    _qtyBtn(Icons.keyboard_arrow_up, () => cart.addToCart(productId, item.title, item.price, item.imageUrl, item.size), isDark),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: isDark ? Colors.white54 : Colors.grey.withOpacity(0.5), size: 20),
                      onPressed: () => cart.removeItem(productId),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap, bool isDark) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: isDark ? const Color(0xFF292B2E) : const Color(0xFFE7E8EA)),
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF8F959E)),
      ),
    );
  }

  Widget _addressPreview(bool isDark) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF222222) : const Color(0xFFF5F6FA),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.location_on_outlined, color: Color(0xFF9775FA)),
      ),
      title: Text(
        "Delivery Address",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black),
      ),
      subtitle: const Text("Alexandria, Egypt 21500", style: TextStyle(color: Color(0xFF8F959E), fontSize: 13)),
      trailing: const Icon(Icons.check_circle, color: Color(0xFF48D861), size: 20),
    );
  }

  Widget _paymentPreview(bool isDark) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF222222) : const Color(0xFFF5F6FA),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.credit_card_outlined, color: Color(0xFF9775FA)),
      ),
      title: Text(
        "Payment Method",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black),
      ),
      subtitle: const Text("Visa Classic **** 7690", style: TextStyle(color: Color(0xFF8F959E), fontSize: 13)),
      trailing: const Icon(Icons.check_circle, color: Color(0xFF48D861), size: 20),
    );
  }

  Widget _orderInfo(CartProvider cart, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Order Info",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
        ),
        const SizedBox(height: 15),
        _rowInfo("Subtotal", "\$${cart.totalAmount.toStringAsFixed(2)}", isDark),
        _rowInfo("Shipping cost", "\$$shipping", isDark),
        const SizedBox(height: 10),
        _rowInfo("Total", "\$${(cart.totalAmount + shipping).toStringAsFixed(2)}", isDark, isTotal: true),
      ],
    );
  }

  Widget _rowInfo(String label, String val, bool isDark, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? (isDark ? Colors.white : Colors.black) : const Color(0xFF8F959E),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 15,
            ),
          ),
          Text(
            val,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isTotal ? 16 : 15,
              color: isTotal ? const Color(0xFF9775FA) : (isDark ? Colors.white : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}