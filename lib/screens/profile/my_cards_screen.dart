import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyCardsScreen extends StatelessWidget {
  const MyCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Payment", // مطابق لعنوان الشاشة في تصميم الـ UI
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black, 
            fontWeight: FontWeight.bold
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: CircleAvatar(
            backgroundColor: isDark ? const Color(0xFF222222) : const Color(0xFFF5F6FA),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black, size: 20),
              // الرجوع حسب مخطط ترتيب الصفحات
              onPressed: () => Navigator.of(context).pop(), 
            ),
          ),
        ),
      ),
      body: SingleChildScrollView( // إضافة التمرير لدعم الشاشات الصغيرة
        child: Column(
          children: [
            const SizedBox(height: 20),
            // عرض البطاقات بشكل أفقي كما في Screen 14
            SizedBox(
              height: 200,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .collection('cards')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return _buildEmptyCardPlaceholder(isDark);
                  }

                  return ListView.builder(
                    scrollDirection: Axis.horizontal, 
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var card = snapshot.data!.docs[index];
                      return _buildCreditCardItem(card, index);
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            // زر إضافة بطاقة جديدة (Add new card) بتصميم الـ UI Kit
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                // التوجه لشاشة إضافة الكارت
                onTap: () => Navigator.pushNamed(context, '/add-card'),
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF222222) : const Color(0xFFF5F2FF), 
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF9775FA), width: 1),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_box_outlined, color: Color(0xFF9775FA)),
                      SizedBox(width: 10),
                      Text(
                        "Add new card",
                        style: TextStyle(
                          color: Color(0xFF9775FA), 
                          fontWeight: FontWeight.bold, 
                          fontSize: 17
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            // ملاحظة: يمكنك هنا إضافة حقول "Card Owner" و "Card Number" للعرض فقط 
            // كما يظهر في الجزء السفلي من Screen 14
          ],
        ),
      ),
    );
  }

  // ودجت لعرض البطاقة الفردية بتصميم الـ UI
  Widget _buildCreditCardItem(DocumentSnapshot card, int index) {
    // توزيع الألوان بالتناوب كما في التصميم
    List<Color> cardColors = index % 2 == 0 
        ? [const Color(0xFFFFCF67), const Color(0xFFEE5A5A)] // أصفر وأحمر
        : [const Color(0xFF436E4F), const Color(0xFF263D2E)]; // أخضر داكن

    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: cardColors, 
          begin: Alignment.topLeft, 
          end: Alignment.bottomRight
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                card['cardOwner'], 
                style: const TextStyle(
                  color: Colors.white, 
                  fontSize: 16, 
                  fontWeight: FontWeight.w600
                )
              ),
              const Text(
                "VISA", 
                style: TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.bold, 
                  fontStyle: FontStyle.italic 
                )
              ),
            ],
          ),
          Text(
            "**** **** **** ${card['cardNumber'].toString().substring(card['cardNumber'].toString().length - 4)}",
            style: const TextStyle(
              color: Colors.white, 
              fontSize: 20, 
              letterSpacing: 2
            ),
          ),
          const Text(
            "\$3,763.87", // قيمة تجريبية كما في التصميم
            style: TextStyle(
              color: Colors.white, 
              fontSize: 18, 
              fontWeight: FontWeight.bold
            )
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCardPlaceholder(bool isDark) {
    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF222222) : Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.3)), 
      ),
      child: const Center(child: Text("No cards available")),
    );
  }
}