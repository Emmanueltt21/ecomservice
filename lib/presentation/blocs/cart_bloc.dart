import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ecomservics/core/resources/data_state.dart';
import 'package:ecomservics/domain/entities/cart_item.dart';
import 'package:ecomservics/domain/entities/product.dart';
import 'package:ecomservics/domain/repositories/cart_repository.dart';

// Events
abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object> get props => [];
}

class GetCart extends CartEvent {}
class AddToCart extends CartEvent {
  final Product product;
  const AddToCart(this.product);
  @override
  List<Object> get props => [product];
}
class RemoveFromCart extends CartEvent {
  final Product product;
  const RemoveFromCart(this.product);
  @override
  List<Object> get props => [product];
}
class UpdateCartQuantity extends CartEvent {
  final Product product;
  final int quantity;
  const UpdateCartQuantity(this.product, this.quantity);
  @override
  List<Object> get props => [product, quantity];
}
class ClearCart extends CartEvent {}

// State
abstract class CartState extends Equatable {
  final List<CartItem> items;
  const CartState({this.items = const []});
  
  double get totalAmount => items.fold(0, (sum, item) => sum + item.totalPrice);
  int get itemCount => items.length;

  @override
  List<Object> get props => [items];
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartLoaded extends CartState {
  const CartLoaded({required super.items});
}

class CartError extends CartState {
  final String message;
  const CartError(this.message);
  @override
  List<Object> get props => [message];
}

// Bloc
class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;

  CartBloc(this._cartRepository) : super(const CartLoading()) {
    on<GetCart>(_onGetCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateCartQuantity>(_onUpdateCartQuantity);
    on<ClearCart>(_onClearCart);
    
    add(GetCart()); // Load on init
  }

  void _onGetCart(GetCart event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    final result = await _cartRepository.getCartItems();
    if (result is DataSuccess) {
      emit(CartLoaded(items: result.data ?? []));
    } else {
      emit(CartError(result.error?.toString() ?? 'Error loading cart'));
    }
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    await _cartRepository.addToCart(event.product);
    add(GetCart());
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) async {
    await _cartRepository.removeFromCart(event.product);
    add(GetCart());
  }

  void _onUpdateCartQuantity(UpdateCartQuantity event, Emitter<CartState> emit) async {
    await _cartRepository.updateQuantity(event.product, event.quantity);
    add(GetCart());
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    await _cartRepository.clearCart();
    add(GetCart());
  }
}
