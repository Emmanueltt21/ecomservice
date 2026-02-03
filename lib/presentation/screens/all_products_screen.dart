import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomservics/presentation/blocs/all_products_bloc.dart';
import 'package:ecomservics/presentation/widgets/product_card.dart';
import 'package:ecomservics/presentation/routes/app_routes.dart';
import 'package:ecomservics/presentation/widgets/shimmer_loading.dart';
import 'package:ecomservics/core/utils/snackbar_helper.dart';
import 'package:ecomservics/core/services/notification_service.dart';
import 'package:ecomservics/presentation/blocs/favorite_bloc.dart';
import 'package:ecomservics/presentation/blocs/cart_bloc.dart';

class AllProductsScreen extends StatefulWidget {
  final String? categoryId;
  final String? categoryName;

  const AllProductsScreen({
    super.key, 
    this.categoryId,
    this.categoryName,
  });

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  final ScrollController _scrollController = ScrollController();
  late AllProductsBloc _allProductsBloc;

  @override
  void initState() {
    super.initState();
    _allProductsBloc = GetIt.I<AllProductsBloc>();
    _allProductsBloc.add(GetAllProducts(categoryId: widget.categoryId));
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _allProductsBloc.add(LoadMoreProducts());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _allProductsBloc,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => context.pop(),
          ),
          title: Text(widget.categoryName ?? 'All Products'),
        ),
        body: BlocBuilder<AllProductsBloc, AllProductsState>(
          builder: (context, state) {
            if (state is AllProductsLoading && state.products.isEmpty) {
              return const ProductGridShimmer();
            }

            if (state is AllProductsError && state.products.isEmpty) {
              return Center(child: Text(state.errorMessage ?? 'An error occurred'));
            }

            return GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: state.hasReachedMax 
                  ? state.products.length 
                  : state.products.length + 1,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.70,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                if (index >= state.products.length) {
                  return const ProductItemShimmer();
                }
                
                final product = state.products[index];
                return BlocBuilder<FavoriteBloc, FavoriteState>(
                  builder: (context, favState) {
                    final isFav = favState.items.any((item) => item.id == product.id);
                    return ProductCard(
                      product: product,
                      isFavorite: isFav,
                      onTap: () => context.push('${AppRoutes.home}/product/${product.id}'),
                      onFavoriteToggle: () {
                        context.read<FavoriteBloc>().add(ToggleFavorite(product));
                        SnackBarHelper.showSuccess(
                          context: context,
                          title: isFav ? 'Removed' : 'Added',
                          message: isFav ? 'Removed from favorites' : 'Added to favorites',
                        );
                      },
                      onAddToCart: () {
                        context.read<CartBloc>().add(AddToCart(product));
                        SnackBarHelper.showSuccess(
                          context: context,
                          title: 'Added!',
                          message: 'Added to your cart',
                        );
                        NotificationService.showNotification(
                          id: product.id.hashCode,
                          title: 'Cart Updated',
                          body: '${product.name} added to cart!',
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
