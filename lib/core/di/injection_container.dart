import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ecomservics/data/datasources/static_data_source.dart';
import 'package:ecomservics/data/datasources/local_data_source.dart';
import 'package:ecomservics/data/repositories/product_repository_impl.dart';
import 'package:ecomservics/data/repositories/category_repository_impl.dart';
import 'package:ecomservics/domain/repositories/product_repository.dart';
import 'package:ecomservics/domain/repositories/category_repository.dart';
import 'package:ecomservics/domain/usecases/get_products.dart';
import 'package:ecomservics/domain/usecases/get_categories.dart';

import '../../data/repositories/cart_repository_impl.dart';
import '../../data/repositories/favorite_repository_impl.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../../domain/usecases/get_product_by_id.dart';
import '../../presentation/blocs/auth_bloc.dart';
import '../../presentation/blocs/cart_bloc.dart';
import '../../presentation/blocs/favorite_bloc.dart';
import '../../presentation/blocs/home_bloc.dart';
import '../../presentation/blocs/language_bloc.dart';
import '../../presentation/blocs/product_bloc.dart';
import '../../presentation/blocs/profile_bloc.dart';
import '../../presentation/blocs/theme_bloc.dart';
import '../../presentation/blocs/all_products_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  
  await Hive.initFlutter();
  final box = await Hive.openBox('ecom_cache');
  sl.registerLazySingleton(() => box);

  // Core
  
  // Data Sources
  sl.registerLazySingleton<StaticDataSource>(() => StaticDataSource());
  sl.registerLazySingleton<LocalDataSource>(() => LocalDataSource(sl()));
  
  // Repositories
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(sl()));
  sl.registerLazySingleton<FavoriteRepository>(() => FavoriteRepositoryImpl(sl()));
  
  // Use Cases
  sl.registerLazySingleton<GetProductsUseCase>(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton<GetCategoriesUseCase>(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton<GetProductByIdUseCase>(() => GetProductByIdUseCase(sl()));
  
  // Blocs (app-level state as singletons, screen-level as factories)
  sl.registerLazySingleton(() => ThemeBloc(sharedPreferences: sl()));
  sl.registerLazySingleton(() => LanguageBloc(sharedPreferences: sl()));
  sl.registerLazySingleton(() => AuthBloc());
  sl.registerLazySingleton(() => CartBloc(sl()));
  sl.registerLazySingleton(() => FavoriteBloc(sl()));
  sl.registerFactory(() => HomeBloc(getCategoriesUseCase: sl(), getProductsUseCase: sl()));
  sl.registerFactory(() => ProductBloc(sl()));
  sl.registerFactory(() => AllProductsBloc(sl()));
  sl.registerFactory(() => ProfileBloc());
}
