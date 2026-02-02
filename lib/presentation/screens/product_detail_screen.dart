import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecomservics/domain/entities/product.dart';
import 'package:ecomservics/presentation/blocs/product_bloc.dart';
import 'package:ecomservics/presentation/blocs/cart_bloc.dart';
import 'package:ecomservics/presentation/blocs/favorite_bloc.dart';
import 'package:ecomservics/presentation/widgets/product_detail_shimmer.dart';
import 'package:go_router/go_router.dart';

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

class _ProductDetailView extends StatefulWidget {
  const _ProductDetailView();

  @override
  State<_ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<_ProductDetailView> {
  int _currentImageIndex = 0;
  bool _isDescriptionExpanded = false;
  int _selectedColorIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF161a2e) : Colors.white,
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const SafeArea(
              child: ProductDetailShimmer(),
            );
          } else if (state is ProductError) {
            return Center(child: Text(state.message));
          } else if (state is ProductLoaded) {
            final product = state.product;
            
            // Mock data for demo
            final productImages = List.generate(4, (index) => product.image);
            final availableColors = [
              const Color(0xFF1c1c1c),
              const Color(0xFFe5e5e5),
              const Color(0xFF008080),
            ];

            return Stack(
              children: [
                SafeArea(
                  child: CustomScrollView(
                    slivers: [
                      // Toolbar
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _CircleIconButton(
                                icon: Icons.arrow_back_ios_new,
                                onTap: () => context.pop(),
                              ),
                              Row(
                                children: [
                                  _CircleIconButton(
                                    icon: Icons.share,
                                    onTap: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Share feature coming soon')),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  _CircleIconButton(
                                    icon: Icons.shopping_bag_outlined,
                                    onTap: () => context.go('/cart'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Image Gallery with Indicators
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              Container(
                                height: 350,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: isDark ? Colors.grey[800] : Colors.grey[100],
                                ),
                                child: Stack(
                                  children: [
                                    PageView.builder(
                                      itemCount: productImages.length,
                                      onPageChanged: (index) {
                                        setState(() => _currentImageIndex = index);
                                      },
                                      itemBuilder: (context, index) {
                                        return ClipRRect(
                                          borderRadius: BorderRadius.circular(16),
                                          child: CachedNetworkImage(
                                            imageUrl: productImages[index],
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                          ),
                                        );
                                      },
                                    ),
                                    // Indicators
                                    Positioned(
                                      bottom: 20,
                                      left: 0,
                                      right: 0,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: List.generate(
                                          productImages.length,
                                          (index) => Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 4),
                                            width: index == _currentImageIndex ? 24 : 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: index == _currentImageIndex
                                                  ? theme.primaryColor
                                                  : Colors.white.withOpacity(0.5),
                                              borderRadius: BorderRadius.circular(3),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Product Info
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'PREMIUM AUDIO',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.2,
                                            color: theme.primaryColor.withOpacity(0.7),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          product.name,
                                          style: theme.textTheme.headlineMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            height: 1.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF008080).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '\$${product.price.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        color: Color(0xFF008080),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Rating Summary
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: isDark ? Colors.grey[800]! : Colors.grey[100]!,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.star, color: Color(0xFF008080), size: 20),
                                    const SizedBox(width: 4),
                                    Text(
                                      product.rating.toString(),
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    const SizedBox(width: 16),
                                    Container(
                                      width: 1,
                                      height: 16,
                                      color: isDark ? Colors.grey[700] : Colors.grey[300],
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      '124 Reviews',
                                      style: TextStyle(
                                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '98% Recommendation',
                                      style: TextStyle(
                                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Available Colors
                              const SizedBox(height: 24),
                              Text(
                                'Available Colors',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: List.generate(
                                  availableColors.length,
                                  (index) => GestureDetector(
                                    onTap: () => setState(() => _selectedColorIndex = index),
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 12),
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: _selectedColorIndex == index
                                              ? theme.primaryColor
                                              : Colors.transparent,
                                          width: 2,
                                        ),
                                      ),
                                      child: Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: availableColors[index],
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Description
                              const SizedBox(height: 32),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Description',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    _isDescriptionExpanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: Colors.grey[400],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                product.description,
                                maxLines: _isDescriptionExpanded ? null : 3,
                                overflow: _isDescriptionExpanded ? null : TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                  fontSize: 15,
                                  height: 1.5,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() => _isDescriptionExpanded = !_isDescriptionExpanded);
                                },
                                child: Text(
                                  _isDescriptionExpanded ? 'Read Less' : 'Read More',
                                  style: TextStyle(
                                    color: theme.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                              // Ratings Breakdown
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isDark 
                                      ? const Color(0xFF101322).withOpacity(0.3)
                                      : const Color(0xFFf6f6f8),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Overall Rating
                                    Column(
                                      children: [
                                        Text(
                                          product.rating.toString(),
                                          style: const TextStyle(
                                            fontSize: 36,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        Row(
                                          children: List.generate(
                                            5,
                                            (index) => Icon(
                                              Icons.star,
                                              color: theme.primaryColor,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 32),
                                    // Rating Bars
                                    Expanded(
                                      child: Column(
                                        children: [
                                          _RatingBar(rating: 5, percentage: 90, isDark: isDark),
                                          _RatingBar(rating: 4, percentage: 8, isDark: isDark),
                                          _RatingBar(rating: 3, percentage: 2, isDark: isDark),
                                          _RatingBar(rating: 2, percentage: 0, isDark: isDark),
                                          _RatingBar(rating: 1, percentage: 0, isDark: isDark),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 100), // Space for sticky footer
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Sticky Footer
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16).copyWith(bottom: 32),
                    decoration: BoxDecoration(
                      color: (isDark ? const Color(0xFF161a2e) : Colors.white).withOpacity(0.9),
                      border: Border(
                        top: BorderSide(
                          color: isDark ? Colors.grey[800]! : Colors.grey[100]!,
                        ),
                      ),
                      backgroundBlendMode: BlendMode.srcOver,
                    ),
                    child: Row(
                      children: [
                        BlocBuilder<FavoriteBloc, FavoriteState>(
                          builder: (context, favState) {
                            final isFav = favState.items.any((item) => item.id == product.id);
                            return Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: isDark ? Colors.grey[800] : Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  isFav ? Icons.favorite : Icons.favorite_border,
                                  color: isFav ? Colors.red : (isDark ? Colors.white : Colors.black),
                                ),
                                onPressed: () {
                                  context.read<FavoriteBloc>().add(ToggleFavorite(product));
                                },
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () {
                              context.read<CartBloc>().add(AddToCart(product));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${product.name} added to cart')),
                              );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.shopping_cart),
                            label: const Text(
                              'Add to Cart',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
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

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isDark 
              ? const Color(0xFF101322).withOpacity(0.5)
              : const Color(0xFFf6f6f8),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }
}

class _RatingBar extends StatelessWidget {
  final int rating;
  final int percentage;
  final bool isDark;

  const _RatingBar({
    required this.rating,
    required this.percentage,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 12,
            child: Text(
              rating.toString(),
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[700] : Colors.grey[200],
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage / 100,
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 36,
            child: Text(
              '$percentage%',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey[500] : Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
