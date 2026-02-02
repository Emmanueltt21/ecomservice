import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ecomservics/core/resources/data_state.dart';
import 'package:ecomservics/domain/entities/product.dart';
import 'package:ecomservics/domain/usecases/get_products.dart';

// Events
abstract class AllProductsEvent extends Equatable {
  const AllProductsEvent();
  @override
  List<Object?> get props => [];
}

class GetAllProducts extends AllProductsEvent {
  final String? categoryId;
  final bool refresh;
  const GetAllProducts({this.categoryId, this.refresh = false});
  @override
  List<Object?> get props => [categoryId, refresh];
}

class LoadMoreProducts extends AllProductsEvent {}

// State
abstract class AllProductsState extends Equatable {
  final List<Product> products;
  final bool hasReachedMax;
  final String? errorMessage;

  const AllProductsState({
    this.products = const [],
    this.hasReachedMax = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [products, hasReachedMax, errorMessage];
}

class AllProductsInitial extends AllProductsState {}
class AllProductsLoading extends AllProductsState {
  const AllProductsLoading({super.products, super.hasReachedMax});
}
class AllProductsLoaded extends AllProductsState {
  const AllProductsLoaded({required super.products, required super.hasReachedMax});
}
class AllProductsError extends AllProductsState {
  const AllProductsError({required super.errorMessage, super.products, super.hasReachedMax});
}

// Bloc
class AllProductsBloc extends Bloc<AllProductsEvent, AllProductsState> {
  final GetProductsUseCase _getProductsUseCase;
  int _currentPage = 1;
  static const int _pageSize = 10;
  String? _currentCategoryId;

  AllProductsBloc(this._getProductsUseCase) : super(AllProductsInitial()) {
    on<GetAllProducts>(_onGetAllProducts);
    on<LoadMoreProducts>(_onLoadMoreProducts);
  }

  Future<void> _onGetAllProducts(GetAllProducts event, Emitter<AllProductsState> emit) async {
    if (event.refresh) {
      _currentPage = 1;
    }
    
    _currentCategoryId = event.categoryId;
    emit(const AllProductsLoading());
    
    final result = await _getProductsUseCase(
      page: _currentPage,
      limit: _pageSize,
      categoryId: _currentCategoryId,
    );

    if (result is DataSuccess && result.data != null) {
      final products = result.data!;
      _currentPage++;
      emit(AllProductsLoaded(
        products: products,
        hasReachedMax: products.length < _pageSize,
      ));
    } else {
      emit(AllProductsError(errorMessage: result.error?.toString() ?? 'Failed to load products'));
    }
  }

  Future<void> _onLoadMoreProducts(LoadMoreProducts event, Emitter<AllProductsState> emit) async {
    if (state.hasReachedMax || state is AllProductsLoading) return;

    final result = await _getProductsUseCase(
      page: _currentPage,
      limit: _pageSize,
      categoryId: _currentCategoryId,
    );

    if (result is DataSuccess && result.data != null) {
      final newProducts = result.data!;
      if (newProducts.isEmpty) {
        emit(AllProductsLoaded(products: state.products, hasReachedMax: true));
      } else {
        _currentPage++;
        emit(AllProductsLoaded(
          products: List.of(state.products)..addAll(newProducts),
          hasReachedMax: newProducts.length < _pageSize,
        ));
      }
    } else {
      // Keep current products but show error or just ignore for now
      emit(AllProductsError(
        errorMessage: result.error?.toString() ?? 'Failed to load more products',
        products: state.products,
        hasReachedMax: state.hasReachedMax,
      ));
    }
  }
}
