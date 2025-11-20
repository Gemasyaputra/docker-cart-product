import 'dart:convert';
import 'package:http/http.dart' as http;
// Pastikan nama file dan path impor sudah benar
import '../model/ModelProduct.dart';


class ProductService {
  // Untuk Android Emulator gunakan 10.0.2.2
  static const String baseUrl = 'http://10.0.2.2:3000';

  // Ubah 'Product' menjadi 'ModelProduct'
  Future<List<ModelProduct>> getProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        // Ubah 'Product.fromJson' menjadi 'ModelProduct.fromJson'
        return data.map((json) => ModelProduct.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  // Ubah 'Product' menjadi 'ModelProduct'
  Future<ModelProduct> getProductById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products/$id'));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        // Ubah 'Product.fromJson' menjadi 'ModelProduct.fromJson'
        return ModelProduct.fromJson(data);
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }
}