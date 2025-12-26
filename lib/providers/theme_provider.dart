import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // تحسين دالة التبديل لضمان استجابة التطبيق الفورية
  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); 
  }

  // تعريف ألوان الـ Dark Mode العميقة كما طلبت في الملاحظات
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF9775FA),
    scaffoldBackgroundColor: const Color(0xFF1D1E20), // لون أسود عميق مطابق للتصميم
    canvasColor: const Color(0xFF1D1E20),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1D1E20),
      elevation: 0,
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF9775FA),
      secondary: Color(0xFF9775FA),
      surface: Color(0xFF292B2E), // لون الحاويات في الوضع المظلم
    ),
  );

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF9775FA),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
    ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF9775FA),
    ),
  );
}