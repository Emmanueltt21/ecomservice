import 'package:ecomservics/core/resources/data_state.dart';
import 'package:ecomservics/domain/entities/product.dart';
import 'package:ecomservics/domain/repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository _productRepository;

  GetProductsUseCase(this._productRepository);

  Future<DataState<List<Product>>> call({
    int page = 1, 
    int limit = 10,
    String? categoryId, 
    String? query
  }) {
    return _productRepository.getProducts(
      page: page, 
      limit: limit, 
      categoryId: categoryId, 
      query: query
    );
  }
}
