import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomservics/presentation/routes/app_routes.dart';
import 'package:ecomservics/presentation/screens/splash_screen.dart';
import 'package:ecomservics/presentation/screens/login_screen.dart';
import 'package:ecomservics/presentation/screens/home_screen.dart';
import 'package:ecomservics/presentation/screens/main_screen.dart';
import 'package:ecomservics/presentation/screens/cart_screen.dart';
import 'package:ecomservics/presentation/screens/favorites_screen.dart';
import 'package:ecomservics/presentation/screens/profile_screen.dart';

import '../screens/product_detail_screen.dart';

// Placeholder screens if they don't exist yet, to avoid errors while updating router
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen(this.title, {super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(title)), body: Center(child: Text(title)));
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorCartKey = GlobalKey<NavigatorState>(debugLabel: 'shellCart');
final _shellNavigatorFavoritesKey = GlobalKey<NavigatorState>(debugLabel: 'shellFavorites');
final _shellNavigatorProfileKey = GlobalKey<NavigatorState>(debugLabel: 'shellProfile');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorHomeKey,
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
              routes: [
                // Product detail as a child route of home
                GoRoute(
                  path: 'product/:id',
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return ProductDetailScreen(productId: id);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorCartKey,
          routes: [
            GoRoute(
              path: AppRoutes.cart,
              builder: (context, state) => const CartScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorFavoritesKey,
          routes: [
            GoRoute(
              path: '/favorites', // Need to add to AppRoutes if not there. Assuming AppRoutes.favorites exists?
              // Checking AppRoutes.. I only defined splash, login, home, cart, profile.
              // I will use string literal for now or update AppRoutes later.
              // Actually I'll use string literal or assume I update AppRoutes.
              builder: (context, state) => const FavoritesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorProfileKey,
          routes: [
             GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
         StatefulShellBranch(
          routes: [
             GoRoute(
              path: '/more', 
              builder: (context, state) => const PlaceholderScreen('More'), 
            ),
          ],
        ),
      ],
    ),
  ],
);
