import 'package:ecomservics/core/resources/data_state.dart';
import 'package:ecomservics/domain/entities/category.dart';
import 'package:ecomservics/domain/repositories/category_repository.dart';

class GetCategoriesUseCase {
  final CategoryRepository _categoryRepository;

  GetCategoriesUseCase(this._categoryRepository);

  Future<DataState<List<Category>>> call() {
    return _categoryRepository.getCategories();
  }
}
