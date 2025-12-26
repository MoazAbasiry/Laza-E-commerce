import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // خلفية الصورة - تم تغيير الرابط لصورة موديل رجل أنيق
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1617137968427-85924c800a22?q=80&w=1000',
                ),
                fit: BoxFit.cover,
                // إضافة تعتيم بسيط في الأعلى لجعل الصورة تبدو احترافية
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          
          // الحاوية البيضاء السفلية
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(15), 
              height: MediaQuery.of(context).size.height * 0.35,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20), 
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  )
                ]
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Look Good, Feel Good",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25, 
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1D1E20), 
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Create your individual & unique style and look amazing everyday.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF8F959E), 
                      fontSize: 15, 
                      height: 1.4,
                    ),
                  ),
                  const Spacer(),
                  
                  // أزرار اختيار الجنس
                  Row(
                    children: [
                      Expanded(
                        child: _buildGenderBtn(context, "Men", const Color(0xFFF5F6FA), const Color(0xFF8F959E)),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildGenderBtn(context, "Women", const Color(0xFF9775FA), Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  
                  // رابط التخطي
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/get-started'),
                    child: const Text(
                      "Skip", 
                      style: TextStyle(
                        color: Color(0xFF8F959E), 
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderBtn(BuildContext context, String text, Color bgColor, Color textColor) {
    return SizedBox(
      height: 60, 
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, '/get-started'),
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(
          text, 
          style: const TextStyle(
            fontWeight: FontWeight.w500, 
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}