import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecomservics/domain/entities/product.dart';
import 'package:ecomservics/presentation/blocs/product_bloc.dart';
import 'package:ecomservics/presentation/blocs/cart_bloc.dart';
import 'package:ecomservics/presentation/blocs/favorite_bloc.dart';
import 'package:ecomservics/generated/app_localizations.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<ProductBloc>()..add(GetProductDetail(productId)),
      child: const _ProductDetailView(),
    );
  }
}

class _ProductDetailView extends StatelessWidget {
  const _ProductDetailView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoaded) {
                return BlocBuilder<FavoriteBloc, FavoriteState>(
                  builder: (context, favState) {
                    final isFav = favState.items.any((item) => item.id == state.product.id);
                    return IconButton(
                      icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : null),
                      onPressed: () {
                        context.read<FavoriteBloc>().add(ToggleFavorite(state.product));
                      },
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductError) {
            return Center(child: Text(state.message));
          } else if (state is ProductLoaded) {
            final product = state.product;
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          imageUrl: product.image,
                          width: double.infinity,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.name, style: Theme.of(context).textTheme.headlineSmall),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (product.oldPrice != null) ...[
                                    const SizedBox(width: 8),
                                    Text(
                                      '\$${product.oldPrice!.toStringAsFixed(2)}',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 16),
                               Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber),
                                  const SizedBox(width: 4),
                                  Text(product.rating.toString(), style: Theme.of(context).textTheme.bodyLarge),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text('Description', style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              Text(product.description, style: Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                         context.read<CartBloc>().add(AddToCart(product));
                         ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(content: Text('${product.name} added to cart')),
                         );
                      },
                      icon: const Icon(Icons.shopping_cart),
                      label: Text(l10n.addToCart),
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
