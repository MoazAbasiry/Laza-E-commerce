import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _ownerController = TextEditingController();
  final _numberController = TextEditingController();
  final _expController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _saveCardInfo = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // تم التغيير من FontWeight.black إلى FontWeight.w900 لحل الخطأ
        title: const Text("PAYMENT", style: TextStyle(fontWeight: FontWeight.w900)),
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عرض الكروت الحالية (Credit Card UI)
            _buildCreditCardPreview(),
            const SizedBox(height: 25),

            // زر إضافة كارت جديد كما في Screen 14
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_box_outlined, color: Color(0xFF9775FA)),
              label: const Text("Add new card", style: TextStyle(color: Color(0xFF9775FA), fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                side: const BorderSide(color: Color(0xFF9775FA)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 30),

            _buildLabel("Card Owner"),
            TextField(controller: _ownerController, decoration: _inputDeco("John Doe")),
            const SizedBox(height: 20),

            _buildLabel("Card Number"),
            TextField(controller: _numberController, keyboardType: TextInputType.number, decoration: _inputDeco("5254 7634 8734 7690")),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLabel("Expiry"), TextField(controller: _expController, decoration: _inputDeco("09/27"))])),
                const SizedBox(width: 15),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLabel("CVV"), TextField(controller: _cvvController, obscureText: true, decoration: _inputDeco("776"))])),
              ],
            ),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Save card info", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                Switch(value: _saveCardInfo, onChanged: (v) => setState(() => _saveCardInfo = v), activeColor: const Color(0xFF9775FA)),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: CustomButton(text: "SAVE CARD", onPressed: () => Navigator.pop(context)),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(text.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)));
  
  InputDecoration _inputDeco(String hint) => InputDecoration(hintText: hint, filled: true, fillColor: Colors.grey[100], border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none));

  Widget _buildCreditCardPreview() {
    return Container(
      width: double.infinity, height: 180,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFFF9C71), Color(0xFFFF5C00)]),
        borderRadius: BorderRadius.circular(25),
      ),
      // تم مسح كلمة const من هنا لأن FontWeight.w900 تمنع استخدامها في بعض الإصدارات
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Alex Dev", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)), Text("VISA", style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontWeight: FontWeight.w900, fontSize: 20))]),
          const Text("5254 **** **** 7690", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 2)),
          const Text("\$3,763.87", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}