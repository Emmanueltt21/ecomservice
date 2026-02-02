import 'package:ecomservics/core/resources/data_state.dart';
import 'package:ecomservics/domain/entities/product.dart';

abstract class FavoriteRepository {
  Future<DataState<List<Product>>> getFavorites();
  Future<DataState<void>> addFavorite(Product product);
  Future<DataState<void>> removeFavorite(Product product);
  Future<DataState<bool>> isFavorite(String productId);
}
