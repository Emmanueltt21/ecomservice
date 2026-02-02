import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomservics/presentation/blocs/favorite_bloc.dart';
import 'package:ecomservics/presentation/widgets/product_card.dart';
import 'package:ecomservics/presentation/routes/app_routes.dart';
import 'package:ecomservics/generated/app_localizations.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use existing singleton FavoriteBloc instead of creating new instance
    return BlocProvider.value(
      value: GetIt.I<FavoriteBloc>(),
      child: const _FavoritesView(),
    );
  }
}

class _FavoritesView extends StatelessWidget {
  const _FavoritesView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.favorites)),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
           if (state is FavoriteLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoriteError) {
            return Center(child: Text(state.message));
          } else {
             final items = state.items;
             if (items.isEmpty) {
               return const Center(child: Text('No favorites yet'));
             }
             return GridView.builder(
               padding: const EdgeInsets.all(8),
               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                 crossAxisCount: 2,
                 childAspectRatio: 0.7,
                 mainAxisSpacing: 8,
                 crossAxisSpacing: 8,
               ),
               itemCount: items.length,
               itemBuilder: (context, index) {
                 final product = items[index];
                 return ProductCard(
                   product: product,
                   isFavorite: true,
                   onFavoriteToggle: () {
                     context.read<FavoriteBloc>().add(ToggleFavorite(product));
                   },
                   onTap: () {
                     context.go('${AppRoutes.home}/product/${product.id}');
                   },
                 );
               },
             );
          }
        },
      ),
    );
  }
}
