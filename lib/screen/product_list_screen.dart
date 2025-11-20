// lib/screens/product_list_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:pruductservice/model/ModelProduct.dart';
import 'package:pruductservice/screen/product_detail.dart';
import 'package:pruductservice/providers/cart_provider.dart';
// !!! TAMBAHKAN IMPORT CART SCREEN DI SINI !!!
import 'package:pruductservice/screen/cart_product.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  // CATATAN: Menggunakan IP lokal komputer, harus sama dengan ProductService
  final String apiUrl = "http://192.168.100.109:3000/products";
  late Future<List<ModelProduct>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = _fetchProducts();
  }

  Future<List<ModelProduct>> _fetchProducts() async {
    // ... (Fungsi _fetchProducts tetap sama)
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        return modelProductFromJson(response.body);
      } else {
        throw Exception('Gagal mengambil data produk. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan atau server: $e');
    }
  }

  // Fungsi untuk menampilkan SnackBar konfirmasi
  void _showAddToCartSnackbar(BuildContext context, String productName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$productName ditambahkan ke keranjang.'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🛒 Daftar Produk API'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          // Widget untuk menampilkan jumlah item di keranjang (opsional)
          // Menggunakan Consumer agar hanya bagian ini yang mendengarkan perubahan keranjang
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      // --- PERBAIKAN INI ---
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          // Asumsi CartScreen Anda berada di 'cart_product.dart'
                          builder: (context) => CartScreen(),
                        ),
                      );
                      // --------------------
                    },
                  ),
                  if (cartProvider.totalItems > 0)
                    Positioned(
                      right: 5,
                      top: 5,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          cartProvider.totalItems.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<ModelProduct>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}. Cek koneksi server Anda.'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  leading: const Icon(Icons.shop), // Ikon untuk produk
                  title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Harga: Rp ${product.price.toDouble().toStringAsFixed(0)}'),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // IconButton(
                      //   icon: const Icon(Icons.add_shopping_cart, color: Colors.deepPurple),
                      //   onPressed: () {
                      //     cart.addToCart(product);
                      //     _showAddToCartSnackbar(context, product.name);
                      //   },
                      // ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(product: product),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('Tidak ada produk yang tersedia.'));
          }
        },
      ),
    );
  }
}