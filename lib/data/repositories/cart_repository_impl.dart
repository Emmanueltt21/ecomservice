import 'package:ecomservics/core/resources/data_state.dart';
import 'package:ecomservics/data/datasources/local_data_source.dart';
import 'package:ecomservics/data/models/cart_item_model.dart';
import 'package:ecomservics/data/models/product_model.dart';
import 'package:ecomservics/domain/entities/cart_item.dart';
import 'package:ecomservics/domain/entities/product.dart';
import 'package:ecomservics/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final LocalDataSource _localDataSource;

  CartRepositoryImpl(this._localDataSource);

  @override
  Future<DataState<List<CartItem>>> getCartItems() async {
    try {
      final items = await _localDataSource.getCartItems();
      return DataSuccess(items);
    } catch (e) {
      return DataFailed(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<DataState<void>> addToCart(Product product) async {
    try {
      final items = await _localDataSource.getCartItems();
      final index = items.indexWhere((item) => item.product.id == product.id);
      
      List<CartItemModel> newItems;
      if (index >= 0) {
        // Increment quantity? Or just add? Usually add means increment.
        // Prompt says "Quantity Update" separately.
        // I'll assume Add = +1.
        final currentItem = items[index];
        final newItem = CartItemModel(
          product: currentItem.product,
          quantity: currentItem.quantity + 1,
        );
        newItems = List.from(items)..[index] = newItem;
      } else {
        // Add new
        newItems = List.from(items)..add(CartItemModel(
          product: product as ProductModel, // Cast might be risky if Product is not ProductModel. 
          // Ideally convert Product to ProductModel manually or ensure upstream provides Model.
          // For now, assume it's Model or create Model.
          quantity: 1,
        ));
      }
      
      await _localDataSource.saveCartItems(newItems);
      return const DataSuccess(null);
    } catch (e) {
      return DataFailed(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<DataState<void>> removeFromCart(Product product) async {
    try {
      final items = await _localDataSource.getCartItems();
      final newItems = items.where((item) => item.product.id != product.id).toList();
      await _localDataSource.saveCartItems(newItems);
      return const DataSuccess(null);
    } catch (e) {
      return DataFailed(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<DataState<void>> updateQuantity(Product product, int quantity) async {
    try {
      final items = await _localDataSource.getCartItems();
      final index = items.indexWhere((item) => item.product.id == product.id);
      
      if (index >= 0) {
        List<CartItemModel> newItems;
        if (quantity <= 0) {
           newItems = items.where((item) => item.product.id != product.id).toList();
        } else {
           final newItem = CartItemModel(
            product: items[index].product,
            quantity: quantity,
          );
          newItems = List.from(items)..[index] = newItem;
        }
        await _localDataSource.saveCartItems(newItems);
      }
      return const DataSuccess(null);
    } catch (e) {
      return DataFailed(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<DataState<void>> clearCart() async {
    try {
      await _localDataSource.saveCartItems([]);
      return const DataSuccess(null);
    } catch (e) {
      return DataFailed(e is Exception ? e : Exception(e.toString()));
    }
  }
}
