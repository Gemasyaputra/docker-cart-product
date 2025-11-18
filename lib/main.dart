// main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Pastikan jalur impor ini benar

import 'package:pruductservice/providers/cart_provider.dart';
import 'package:pruductservice/screen/product_list_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Set ProductListScreen sebagai halaman awal
      home: const ProductListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}