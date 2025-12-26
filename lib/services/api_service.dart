import 'dart:convert';
import 'package:http/http.dart' as http; //
import '../models/product.dart';

class ApiService {
  // الرابط الأساسي للمنتجات من الموقع
  static const String productsUrl = "https://api.escuelajs.co/api/v1/products";

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(productsUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception("فشل في جلب المنتجات من الـ API");
    }
  }
}