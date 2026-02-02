import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ecomservics/core/resources/data_state.dart';
import 'package:ecomservics/domain/entities/product.dart';
import 'package:ecomservics/domain/usecases/get_product_by_id.dart';

// Events
abstract class ProductEvent extends Equatable {
  const ProductEvent();
  @override
  List<Object> get props => [];
}

class GetProductDetail extends ProductEvent {
  final String id;
  const GetProductDetail(this.id);
  @override
  List<Object> get props => [id];
}

// State
abstract class ProductState extends Equatable {
  const ProductState();
  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}
class ProductLoading extends ProductState {}
class ProductLoaded extends ProductState {
  final Product product;
  const ProductLoaded(this.product);
  @override
  List<Object> get props => [product];
}
class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);
  @override
  List<Object> get props => [message];
}

// Bloc
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductByIdUseCase getProductByIdUseCase;

  ProductBloc(this.getProductByIdUseCase) : super(ProductInitial()) {
    on<GetProductDetail>(_onGetProductDetail);
  }

  void _onGetProductDetail(GetProductDetail event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final result = await getProductByIdUseCase(event.id);
    if (result is DataSuccess && result.data != null) {
      emit(ProductLoaded(result.data!));
    } else {
      emit(ProductError(result.error?.toString() ?? 'Failed to load product'));
    }
  }
}
