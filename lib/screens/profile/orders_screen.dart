import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    // استدعاء دالة الجلب التي قمت ببرمجتها فور فتح الشاشة
    Future.delayed(Duration.zero, () {
      if (mounted) {
        Provider.of<OrderProvider>(context, listen: false).fetchOrders();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // الاستماع للمتغير _orders الموجود في الـ Provider الخاص بك
    final orderProvider = Provider.of<OrderProvider>(context);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("My Orders"), centerTitle: true),
      body: orderProvider.orders.isEmpty
          ? const Center(child: Text("No orders found in Firestore"))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: orderProvider.orders.length,
              itemBuilder: (context, index) {
                final order = orderProvider.orders[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF222222) : const Color(0xFFF5F6FA),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ExpansionTile( // لعرض المنتجات داخل الطلب
                    title: Text("Order #${order.id.substring(0, 5)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("\$${order.amount.toStringAsFixed(2)} - ${order.dateTime.day}/${order.dateTime.month}"),
                    children: order.products.map((p) => ListTile(
                      title: Text(p.title),
                      trailing: Text("x${p.quantity}"),
                    )).toList(),
                  ),
                );
              },
            ),
    );
  }
}