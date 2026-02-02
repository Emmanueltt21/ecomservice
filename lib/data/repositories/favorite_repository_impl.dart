import 'package:ecomservics/core/resources/data_state.dart';
import 'package:ecomservics/data/datasources/local_data_source.dart';
import 'package:ecomservics/data/models/product_model.dart';
import 'package:ecomservics/domain/entities/product.dart';
import 'package:ecomservics/domain/repositories/favorite_repository.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final LocalDataSource _localDataSource;

  FavoriteRepositoryImpl(this._localDataSource);

  @override
  Future<DataState<List<Product>>> getFavorites() async {
    try {
      final items = await _localDataSource.getFavorites();
      return DataSuccess(items);
    } catch (e) {
      return DataFailed(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<DataState<void>> addFavorite(Product product) async {
    try {
      final items = await _localDataSource.getFavorites();
      if (!items.any((item) => item.id == product.id)) {
        final newItems = List<ProductModel>.from(items)..add(product as ProductModel);
        await _localDataSource.saveFavorites(newItems);
      }
      return const DataSuccess(null);
    } catch (e) {
      return DataFailed(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<DataState<void>> removeFavorite(Product product) async {
    try {
      final items = await _localDataSource.getFavorites();
      final newItems = items.where((item) => item.id != product.id).toList();
      await _localDataSource.saveFavorites(newItems);
      return const DataSuccess(null);
    } catch (e) {
      return DataFailed(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<DataState<bool>> isFavorite(String productId) async {
    try {
      final items = await _localDataSource.getFavorites();
      return DataSuccess(items.any((item) => item.id == productId));
    } catch (e) {
      return DataFailed(e is Exception ? e : Exception(e.toString()));
    }
  }
}
