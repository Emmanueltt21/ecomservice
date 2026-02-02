import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ecomservics/core/resources/data_state.dart';
import 'package:ecomservics/domain/entities/category.dart';
import 'package:ecomservics/domain/entities/product.dart';
import 'package:ecomservics/domain/usecases/get_categories.dart';
import 'package:ecomservics/domain/usecases/get_products.dart';

// Events
abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object> get props => [];
}

class GetHomeData extends HomeEvent {}

class RefreshHomeData extends HomeEvent {}

// State
abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Category> categories;
  final List<Product> trendingProducts;
  final List<Product> newProducts;
  final List<Product> allProducts;

  const HomeLoaded({
    this.categories = const [],
    this.trendingProducts = const [],
    this.newProducts = const [],
    this.allProducts = const [],
  });
  
  @override
  List<Object> get props => [categories, trendingProducts, newProducts, allProducts];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
  @override
  List<Object> get props => [message];
}

// Bloc
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsUseCase getProductsUseCase;

  HomeBloc({
    required this.getCategoriesUseCase,
    required this.getProductsUseCase,
  }) : super(HomeLoading()) {
    on<GetHomeData>(_onGetHomeData);
    on<RefreshHomeData>(_onRefreshHomeData);
  }

  void _onGetHomeData(GetHomeData event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final categoriesState = await getCategoriesUseCase();
      final productsState = await getProductsUseCase(page: 1, limit: 20); // Fetch enough for home sections

      if (categoriesState is DataSuccess && productsState is DataSuccess) {
        final products = productsState.data ?? [];
        
        final trending = products.where((p) => p.isTrending).toList();
        final newArrivals = products.where((p) => p.isNew).toList();
        
        emit(HomeLoaded(
          categories: categoriesState.data ?? [],
          trendingProducts: trending,
          newProducts: newArrivals,
          allProducts: products, // Or fetch more if pagination needed
        ));
      } else {
         // Handle error if either fails
         emit(HomeError(productsState.error?.toString() ?? categoriesState.error?.toString() ?? "Failed to load data"));
      }
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void _onRefreshHomeData(RefreshHomeData event, Emitter<HomeState> emit) {
    add(GetHomeData());
  }
}
