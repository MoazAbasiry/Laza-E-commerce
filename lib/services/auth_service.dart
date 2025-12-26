class AuthService {
  // محاكاة لعملية تسجيل الدخول (يمكنك ربطها بـ Firebase لاحقاً)
  Future<Map<String, dynamic>?> login(String email, String password) async {
    // تأخير بسيط لمحاكاة طلب الإنترنت
    await Future.delayed(const Duration(seconds: 2));
    
    if (email.isNotEmpty && password.length >= 6) {
      return {
        'id': '123',
        'name': 'Moaz User',
        'email': email,
      };
    }
    return null;
  }

  Future<bool> register(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    return true; // محاكاة لنجاح التسجيل
  }
}