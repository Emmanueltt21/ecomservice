import 'package:ecomservics/core/resources/data_state.dart';
import 'package:ecomservics/data/datasources/local_data_source.dart';
import 'package:ecomservics/data/datasources/static_data_source.dart';
import 'package:ecomservics/domain/entities/category.dart';
import 'package:ecomservics/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final StaticDataSource _staticDataSource;
  final LocalDataSource _localDataSource;

  CategoryRepositoryImpl(this._staticDataSource, this._localDataSource);

  @override
  Future<DataState<List<Category>>> getCategories() async {
    try {
      // Try remote first (simulated)
      final categories = await _staticDataSource.getCategories();
      // Cache
      await _localDataSource.cacheCategories(categories);
      return DataSuccess(categories);
    } catch (e) {
      // Fallback to local
      try {
        final localCategories = await _localDataSource.getLastCategories();
        if (localCategories.isNotEmpty) {
          return DataSuccess(localCategories);
        }
      } catch (_) {}
      return DataFailed(e is Exception ? e : Exception(e.toString()));
    }
  }
}
