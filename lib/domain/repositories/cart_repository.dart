import 'package:ecomservics/core/resources/data_state.dart';
import 'package:ecomservics/domain/entities/cart_item.dart';
import 'package:ecomservics/domain/entities/product.dart';

abstract class CartRepository {
  Future<DataState<List<CartItem>>> getCartItems();
  Future<DataState<void>> addToCart(Product product);
  Future<DataState<void>> removeFromCart(Product product);
  Future<DataState<void>> updateQuantity(Product product, int quantity);
  Future<DataState<void>> clearCart();
}
