import 'package:ecomservics/core/resources/data_state.dart';
import 'package:ecomservics/domain/entities/category.dart';

abstract class CategoryRepository {
  Future<DataState<List<Category>>> getCategories();
}
