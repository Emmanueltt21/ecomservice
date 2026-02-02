import 'dart:convert';
import 'package:ecomservics/data/models/category_model.dart';
import 'package:ecomservics/data/models/product_model.dart';
import 'package:hive/hive.dart';

import '../models/cart_item_model.dart';

class LocalDataSource {
  final Box box;
  
  LocalDataSource(this.box);

  static const String _categoriesKey = 'categories';
  static const String _productsKey = 'products';

  Future<void> cacheCategories(List<CategoryModel> categories) async {
    final List<Map<String, dynamic>> jsonList = categories.map((e) => e.toJson()).toList();
    await box.put(_categoriesKey, jsonEncode(jsonList));
  }

  Future<List<CategoryModel>> getLastCategories() async {
    final String? jsonString = box.get(_categoriesKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((e) => CategoryModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<void> cacheProducts(List<ProductModel> products) async {
     // Simple cache of all fetched products for MVP
     final List<Map<String, dynamic>> jsonList = products.map((e) => e.toJson()).toList();
     await box.put(_productsKey, jsonEncode(jsonList));
  }

  Future<List<ProductModel>> getLastProducts() async {
     final String? jsonString = box.get(_productsKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((e) => ProductModel.fromJson(e)).toList();
    }
    return [];
  }
  
  static const String _cartKey = 'cart';

  Future<void> saveCartItems(List<dynamic> items) async {
     // items can be List<CartItemModel>
     final List jsonList = items.map((e) => e.toJson()).toList();
     await box.put(_cartKey, jsonEncode(jsonList));
  }

  Future<List<CartItemModel>> getCartItems() async {
    final String? jsonString = box.get(_cartKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      try {
        return jsonList.map((e) => CartItemModel.fromJson(e)).toList();
      } catch (e) {
        // If schema changes or error
        return [];
      }
    }
    return [];
  }
  
  static const String _favoritesKey = 'favorites';

  Future<void> saveFavorites(List<ProductModel> items) async {
     final List<Map<String, dynamic>> jsonList = items.map((e) => e.toJson()).toList();
     await box.put(_favoritesKey, jsonEncode(jsonList));
  }

  Future<List<ProductModel>> getFavorites() async {
    final String? jsonString = box.get(_favoritesKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      try {
        return jsonList.map((e) => ProductModel.fromJson(e)).toList();
      } catch (e) {
        return [];
      }
    }
    return [];
  }
}
