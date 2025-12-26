import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({super.key});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  double _rating = 4.8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ADD REVIEW"), centerTitle: true, leading: const BackButton()),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Name", style: TextStyle(fontWeight: FontWeight.bold)),
            const TextField(decoration: InputDecoration(hintText: "Type your name")),
            const SizedBox(height: 20),
            const Text("How was your experience?", style: TextStyle(fontWeight: FontWeight.bold)),
            const TextField(maxLines: 4, decoration: InputDecoration(hintText: "Describe your experience")),
            const SizedBox(height: 20),
            const Text("Star Rating", style: TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              value: _rating,
              min: 0, max: 5,
              divisions: 50,
              activeColor: const Color(0xFF9775FA),
              label: _rating.toString(),
              onChanged: (v) => setState(() => _rating = v),
            ),
            const Center(child: Text("4.8", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: CustomButton(text: "Submit Review", onPressed: () => Navigator.pop(context)),
      ),
    );
  }
}