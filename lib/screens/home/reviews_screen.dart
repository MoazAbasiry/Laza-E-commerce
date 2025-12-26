import 'package:flutter/material.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // تم التغيير من FontWeight.black إلى FontWeight.w900 لحل الخطأ
        title: const Text("REVIEWS", style: TextStyle(fontWeight: FontWeight.w900)),
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("245 Reviews", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Row(children: [Text("4.8", style: TextStyle(fontWeight: FontWeight.bold)), Icon(Icons.star, color: Colors.amber, size: 16)]),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/add-review'),
                  icon: const Icon(Icons.edit, size: 18, color: Colors.white),
                  label: const Text("Add Review", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF7043)), // اللون البرتقالي من ريأكت
                )
              ],
            ),
            const SizedBox(height: 30),
            _reviewItem("Jenny Wilson", "13 Sep, 2020", 4.8, "Lorem ipsum dolor sit amet, consectetur adipiscing elit..."),
            _reviewItem("Ronald Richards", "13 Sep, 2020", 4.8, "Lorem ipsum dolor sit amet, consectetur adipiscing elit..."),
          ],
        ),
      ),
    );
  }

  Widget _reviewItem(String name, String date, double rat, String comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(backgroundColor: Colors.grey),
              const SizedBox(width: 15),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontWeight: FontWeight.bold)), Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12))])),
              Text("$rat rating", style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          Text(comment, style: const TextStyle(color: Colors.grey, height: 1.5)),
        ],
      ),
    );
  }
}