// lib/providers/product_provider.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  final Box<Product> productBox;

  ProductProvider(this.productBox) {
    loadProducts();
  }

  List<Product> _products = [];
  List<Product> get products => _products;

  void loadProducts() {
    _products = productBox.values.toList();
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    await productBox.add(product);
    loadProducts();
  }

  Future<void> updateProduct(int index, Product product) async {
    await productBox.putAt(index, product);
    loadProducts();
  }

  Future<void> deleteProduct(int index) async {
    await productBox.deleteAt(index);
    loadProducts();
  }

  Future<void> clearAllProducts() async {
    await productBox.clear();
    loadProducts();
  }
}
