import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecomservics/presentation/blocs/home_bloc.dart';
import 'package:ecomservics/presentation/blocs/cart_bloc.dart';
import 'package:ecomservics/presentation/widgets/product_card.dart';
import 'package:ecomservics/domain/entities/category.dart';
import 'package:ecomservics/domain/entities/product.dart';
import 'package:ecomservics/presentation/routes/app_routes.dart';
import 'package:ecomservics/generated/app_localizations.dart';
import 'package:ecomservics/presentation/widgets/shimmer_loading.dart';
import 'package:ecomservics/core/utils/snackbar_helper.dart';
import 'package:ecomservics/core/services/notification_service.dart';
import 'package:ecomservics/presentation/blocs/favorite_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<HomeBloc>()..add(GetHomeData()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // Sticky Header
              SliverPersistentHeader(
                pinned: true,
                delegate: _HomeHeaderDelegate(l10n, theme),
              ),
            ];
          },
          body: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                // Shimmer loading for each section
                return CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(child: SizedBox(height: 8)),
                    
                    // Carousel Shimmer
                    const SliverToBoxAdapter(child: CarouselShimmer()),
                    
                    // Pagination dots placeholder
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(width: 24, height: 6, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(3))),
                            const SizedBox(width: 6),
                            Container(width: 6, height: 6, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(3))),
                            const SizedBox(width: 6),
                            Container(width: 6, height: 6, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(3))),
                          ],
                        ),
                      ),
                    ),
                    
                    // Categories Section Header & Shimmer
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(l10n.categories, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                            Text('See All', style: theme.textTheme.bodyMedium?.copyWith(color: theme.primaryColor, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: CategoryShimmer()),
                    
                    // Trending Section Header & Shimmer
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(l10n.trending, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                            Text(l10n.viewAll, style: theme.textTheme.bodyMedium?.copyWith(color: theme.primaryColor, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: ProductGridShimmer()),
                    
                    // New Arrivals Section Header & Shimmer
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                        child: Text(l10n.newArrivals, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SliverToBoxAdapter(child: ProductListShimmer()),
                    
                    const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
                  ],
                );
              } else if (state is HomeError) {
                return Center(child: Text(state.message));
              } else if (state is HomeLoaded) {
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<HomeBloc>().add(RefreshHomeData());
                  },
                  child: CustomScrollView(
                    slivers: [
                      const SliverToBoxAdapter(child: SizedBox(height: 8)),
                      
                      // Promo Carousel
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 176, // 44rem ~ 176px if rem=4? Design says h-44. Tailwind h-44 is 11rem = 176px.
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            children: const [
                              _PromoBanner(
                                imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuADO71QOGj9lFRQKIw8iCDnyyr0nV9RTNNXKQChGtgiqj3kcxxxXTr6oGrE4MLG1TfF1bUHKOu0jvH6YA19sX8i72a7s_Rg5yQx8cMHQpT-k36_JSXEfnoTB3_V_HID_T_bW76WDSwetYxcLdFNrOgBsqa0H7QlBwJeg-bjTWAcD8os6rVVsC14dbh8K74joa2_14kx11JB6ZE3KP1oB-oUcrTGxpC9l1hyj3_arwx0uYm83a71k0t-9NzHfNtPha0HcovbKWsyWQ',
                                title: 'Up to 50% Off',
                                subtitle: 'New Season',
                                buttonText: 'Shop Now',
                                color: Color(0xFF1337EC), // Primary
                              ),
                             SizedBox(width: 16),
                              _PromoBanner(
                                imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuB9Ha0C-oTCi6v0YwNYsGi1L_1Ynq8cLbEJhZkiVOeGDbtRvXZ3rPGkw-1Uk91zVRqWrFmEoq63CEXuHozgq0v-EsQDKui1Xx2WdrYqzTo3XbeMQ39T7KsVMznkhSvFJb7t_NPRMZWHwQf7flUa1zz7CTU3ZzbXHsMzUVA4I3_shlIR0kDDJYPzF7tBD1-0Ua-wKLzThcklst4h8BGtXWkz-7oAnDgiN_kNCj6kVJOkl0LBkpAKIyrRbuHsSiH_LSRAPg0ZGxF9Xw',
                                title: 'Latest Tech',
                                subtitle: 'Gadgets',
                                buttonText: 'Explore',
                                color: Color(0xFF14B8A6), // Accent Teal
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Pagination dots (Static for minimal implementation)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(width: 24, height: 6, decoration: BoxDecoration(color: theme.primaryColor, borderRadius: BorderRadius.circular(3))),
                              const SizedBox(width: 6),
                              Container(width: 6, height: 6, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(3))),
                              const SizedBox(width: 6),
                              Container(width: 6, height: 6, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(3))),
                            ],
                          ),
                        ),
                      ),
                      
                      // Categories
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(l10n.categories, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                              GestureDetector(
                                onTap: () => context.push(AppRoutes.allCategories),
                                child: Text('See All', style: theme.textTheme.bodyMedium?.copyWith(color: theme.primaryColor, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 100,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: state.categories.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 24),
                            itemBuilder: (context, index) {
                              return _CategoryItem(category: state.categories[index]);
                            },
                          ),
                        ),
                      ),
                      
                      // Trending
                      if (state.trendingProducts.isNotEmpty) ...[
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(l10n.trending, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                                GestureDetector(
                                  onTap: () => context.push(AppRoutes.allProducts),
                                  child: Text(l10n.viewAll, style: theme.textTheme.bodyMedium?.copyWith(color: theme.primaryColor, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverGrid(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.70, // Matches Design
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final product = state.trendingProducts[index];
                                return BlocBuilder<FavoriteBloc, FavoriteState>(
                                  builder: (context, favState) {
                                    final isFav = favState.items.any((item) => item.id == product.id);
                                    return ProductCard(
                                      product: product,
                                      isFavorite: isFav,
                                      onTap: () => context.go('${AppRoutes.home}/product/${product.id}'),
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
                              childCount: state.trendingProducts.length,
                            ),
                          ),
                        ),
                      ],
                      
                      // New Arrivals
                      if (state.newProducts.isNotEmpty) ...[
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                            child: Text(l10n.newArrivals, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return _NewArrivalItem(
                                  product: state.newProducts[index],
                                  onTap: () => context.go('${AppRoutes.home}/product/${state.newProducts[index].id}'),
                                );
                              },
                              childCount: state.newProducts.length,
                            ),
                          ),
                        ),
                      ],
                      
                      const SliverPadding(padding: EdgeInsets.only(bottom: 100)), // Space for Bottom Nav
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

// Header Delegate
class _HomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  final AppLocalizations l10n;
  final ThemeData theme;

  _HomeHeaderDelegate(this.l10n, this.theme);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: theme.scaffoldBackgroundColor.withOpacity(0.95), // Backdrop blur simulated
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ecomservice',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                  letterSpacing: -0.5,
                ),
              ),
              CircleAvatar(
                backgroundColor: theme.brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[200],
                child: IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {},
                  color: theme.brightness == Brightness.dark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    hintText: 'Search products, brands...',
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    fillColor: theme.brightness == Brightness.dark ? Colors.grey[800] : Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.tune),
                  color: theme.colorScheme.secondary,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 130; // approx height
  @override
  double get minExtent => 130;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}

// Sub-widgets local to this file for now to match design quickly

class _PromoBanner extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String buttonText;
  final Color color;

  const _PromoBanner({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(16),
         color: color.withOpacity(0.1),
         image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Colors.black54, Colors.transparent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(subtitle.toUpperCase(), style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2)),
                const SizedBox(height: 4),
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                  child: Text(buttonText, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final Category category;
  const _CategoryItem({required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: ()=>  context.push('${AppRoutes.allProducts}?categoryId=${category.id}&categoryName=${category.name}'),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
            ),
            child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: CachedNetworkImage(
              imageUrl: category.image,
              color: theme.primaryColor,
              fit: BoxFit.contain,
              placeholder: (context, url) => const SizedBox.shrink(),
              errorWidget: (context, url, error) => const Icon(Icons.category),
            ),
          ),
          ),
          const SizedBox(height: 8),
          Text(category.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _NewArrivalItem extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _NewArrivalItem({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
        ),
        child: Row(
          children: [
             ClipRRect(
               borderRadius: BorderRadius.circular(8),
               child: CachedNetworkImage(
                 imageUrl: product.image,
                 width: 96,
                 height: 96,
                 fit: BoxFit.cover,
               ),
             ),
             const SizedBox(width: 16),
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                   const SizedBox(height: 4),
                   Text(product.description, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 12)),
                   const SizedBox(height: 8),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text('\$${product.price.toStringAsFixed(2)}', style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
                       if (product.price > 100) // Mock logic for 'Free Shipping'
                         Row(
                           children: [
                             Icon(Icons.local_shipping, size: 14, color: Colors.grey[400]),
                             const SizedBox(width: 2),
                             Text('Free Shipping', style: TextStyle(color: Colors.grey[400], fontSize: 10)),
                           ],
                         ),
                     ],
                   )
                 ],
               ),
             ),
          ],
        ),
      ),
    );
  }
}
