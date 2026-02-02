import 'package:ecomservics/core/resources/data_state.dart';
import 'package:ecomservics/data/datasources/local_data_source.dart';
import 'package:ecomservics/data/datasources/static_data_source.dart';
import 'package:ecomservics/domain/entities/product.dart';
import 'package:ecomservics/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final StaticDataSource _staticDataSource;
  final LocalDataSource _localDataSource;

  ProductRepositoryImpl(this._staticDataSource, this._localDataSource);

  @override
  Future<DataState<List<Product>>> getProducts({
    int page = 1,
    int limit = 10,
    String? categoryId,
    String? query,
  }) async {
    try {
      // Try remote
      final products = await _staticDataSource.getProducts(
        page: page,
        limit: limit,
        categoryId: categoryId,
        query: query,
      );
      // Cache (only if page 1 and no filters? Or always?
      // For MVP, if standard fetch, we cache. But pagination makes it tricky.
      // We'll cache if page 1 and no search for simple "Home" caching.)
      if (page == 1 && categoryId == null && query == null) {
        await _localDataSource.cacheProducts(products);
      }
      return DataSuccess(products);
    } catch (e) {
      // Fallback
      if (page == 1 && categoryId == null && query == null) {
        try {
          final local = await _localDataSource.getLastProducts();
          if (local.isNotEmpty) {
            return DataSuccess(local);
          }
        } catch (_) {}
      }
      return DataFailed(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<DataState<Product>> getProductById(String id) async {
    // For static, we just search in generated list? 
    // StaticDataSource doesn't expose getProductById.
    // I'll assume we fetch all and filter or add method to DataSource.
    // I'll add method to DataSource or just fail for now?
    // I'll implement a simple fetch from list.
    try {
      final all = await _staticDataSource.getProducts(limit: 100); 
      final product = all.firstWhere((element) => element.id == id);
      return DataSuccess(product);
    } catch (e) {
      return DataFailed(Exception('Product not found'));
    }
  }
}
