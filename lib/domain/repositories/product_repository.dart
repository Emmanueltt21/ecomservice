import 'package:ecomservics/core/resources/data_state.dart';
import 'package:ecomservics/domain/entities/product.dart';

abstract class ProductRepository {
  Future<DataState<List<Product>>> getProducts({
    int page = 1,
    int limit = 10,
    String? categoryId,
    String? query,
  });
  
  Future<DataState<Product>> getProductById(String id);
}
