import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  bool isPrimary = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ADDRESS"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _input("Full Name", "John Doe"),
            const SizedBox(height: 20),
            Row(children: [Expanded(child: _input("Country", "Egypt")), const SizedBox(width: 15), Expanded(child: _input("City", "Alexandria"))]),
            const SizedBox(height: 20),
            _input("Phone Number", "+20 123 456 7890"),
            const SizedBox(height: 20),
            _input("Street Address", "Smouha, Victor Emanuel St."),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Save as primary address", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                Switch(value: isPrimary, onChanged: (v) => setState(() => isPrimary = v), activeColor: const Color(0xFF9775FA)),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: CustomButton(text: "Save Address", onPressed: () => Navigator.pop(context)),
      ),
    );
  }

  Widget _input(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
        TextField(decoration: InputDecoration(hintText: hint, border: const UnderlineInputBorder())),
      ],
    );
  }
}