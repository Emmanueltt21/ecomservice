import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ecomservics/core/resources/data_state.dart';
import 'package:ecomservics/domain/entities/product.dart';
import 'package:ecomservics/domain/repositories/favorite_repository.dart';

// Events
abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();
  @override
  List<Object> get props => [];
}

class GetFavorites extends FavoriteEvent {}

class ToggleFavorite extends FavoriteEvent {
  final Product product;
  const ToggleFavorite(this.product);
  @override
  List<Object> get props => [product];
}

// State
abstract class FavoriteState extends Equatable {
  final List<Product> items;
  const FavoriteState({this.items = const []});
  @override
  List<Object> get props => [items];
}

class FavoriteLoading extends FavoriteState {
  const FavoriteLoading();
}

class FavoriteLoaded extends FavoriteState {
  const FavoriteLoaded({required super.items});
}

class FavoriteError extends FavoriteState {
  final String message;
  const FavoriteError(this.message);
  @override
  List<Object> get props => [message];
}

// Bloc
class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository _favoriteRepository;

  FavoriteBloc(this._favoriteRepository) : super(const FavoriteLoading()) {
    on<GetFavorites>(_onGetFavorites);
    on<ToggleFavorite>(_onToggleFavorite);
    
    add(GetFavorites());
  }

  void _onGetFavorites(GetFavorites event, Emitter<FavoriteState> emit) async {
    emit(const FavoriteLoading());
    final result = await _favoriteRepository.getFavorites();
    if (result is DataSuccess) {
      emit(FavoriteLoaded(items: result.data ?? []));
    } else {
      emit(FavoriteError(result.error?.toString() ?? 'Error loading favorites'));
    }
  }

  void _onToggleFavorite(ToggleFavorite event, Emitter<FavoriteState> emit) async {
    final currentItems = state.items;
    final isFav = currentItems.any((item) => item.id == event.product.id);
    
    if (isFav) {
      await _favoriteRepository.removeFavorite(event.product);
    } else {
      await _favoriteRepository.addFavorite(event.product);
    }
    add(GetFavorites());
  }
}
