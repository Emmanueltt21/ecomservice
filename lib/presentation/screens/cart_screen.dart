import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecomservics/presentation/blocs/cart_bloc.dart';
import 'package:ecomservics/presentation/blocs/auth_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomservics/generated/app_localizations.dart';

import '../routes/app_routes.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use existing singleton CartBloc instead of creating new instance
    return BlocProvider.value(
      value: GetIt.I<CartBloc>(),
      child: const _CartView(),
    );
  }
}

class _CartView extends StatelessWidget {
  const _CartView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cart),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              context.read<CartBloc>().add(ClearCart());
            },
          ),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartError) {
            return Center(child: Text(state.message));
          } else {
             final items = state.items;
             if (items.isEmpty) {
               return const Center(child: Text('Your cart is empty'));
             }
             return Column(
               children: [
                 Expanded(
                   child: ListView.builder(
                     itemCount: items.length,
                     itemBuilder: (context, index) {
                       final item = items[index];
                       return Card(
                         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                         child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Row(
                             children: [
                               ClipRRect(
                                 borderRadius: BorderRadius.circular(8),
                                 child: CachedNetworkImage(
                                   imageUrl: item.product.image,
                                   width: 60,
                                   height: 60,
                                   fit: BoxFit.cover,
                                 ),
                               ),
                               const SizedBox(width: 16),
                               Expanded(
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text(item.product.name, style: Theme.of(context).textTheme.titleSmall, maxLines: 1),
                                     Text('\$${item.product.price}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).primaryColor)),
                                   ],
                                 ),
                               ),
                               Row(
                                 children: [
                                   IconButton(
                                     icon: const Icon(Icons.remove_circle_outline),
                                     onPressed: () {
                                       if (item.quantity > 1) {
                                         context.read<CartBloc>().add(UpdateCartQuantity(item.product, item.quantity - 1));
                                       } else {
                                         context.read<CartBloc>().add(RemoveFromCart(item.product));
                                       }
                                     },
                                   ),
                                   Text(item.quantity.toString()),
                                   IconButton(
                                     icon: const Icon(Icons.add_circle_outline),
                                     onPressed: () {
                                       context.read<CartBloc>().add(UpdateCartQuantity(item.product, item.quantity + 1));
                                     },
                                   ),
                                 ],
                               ),
                             ],
                           ),
                         ),
                       );
                     },
                   ),
                 ),
                 Container(
                   padding: const EdgeInsets.all(16),
                   decoration: BoxDecoration(
                     color: Theme.of(context).cardColor,
                     boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12, offset: const Offset(0, -5))],
                   ),
                   child: Column(
                     children: [
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                           Text('\$${state.totalAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                         ],
                       ),
                       const SizedBox(height: 16),
                       SizedBox(
                         width: double.infinity,
                         child: FilledButton(
                           onPressed: () {
                             // Check if user is authenticated before checkout
                             final authState = context.read<AuthBloc>().state;
                             if (authState is AuthAuthenticated) {
                               // Logged in - proceed to checkout
                               context.push(AppRoutes.checkout);
                             } else {
                               // Not logged in - redirect to login
                               ScaffoldMessenger.of(context).showSnackBar(
                                 const SnackBar(content: Text('Please login to checkout')),
                               );
                               context.push(AppRoutes.login);
                             }
                           },
                           child: Text(l10n.buyNow),
                         ),
                       ),
                     ],
                   ),
                 ),
               ],
             );
          }
        },
      ),
    );
  }
}
