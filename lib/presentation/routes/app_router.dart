import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomservics/presentation/routes/app_routes.dart';
import 'package:ecomservics/presentation/screens/splash_screen.dart';
import 'package:ecomservics/presentation/screens/login_screen.dart';
import 'package:ecomservics/presentation/screens/signup_screen.dart';
import 'package:ecomservics/presentation/screens/forgot_password_screen.dart';
import 'package:ecomservics/presentation/screens/otp_screen.dart';
import 'package:ecomservics/presentation/screens/home_screen.dart';
import 'package:ecomservics/presentation/screens/main_screen.dart';
import 'package:ecomservics/presentation/screens/cart_screen.dart';
import 'package:ecomservics/presentation/screens/checkout_screen.dart';
import 'package:ecomservics/presentation/screens/order_success_screen.dart';
import 'package:ecomservics/presentation/screens/order_history_screen.dart';
import 'package:ecomservics/presentation/screens/transaction_list_screen.dart';
import 'package:ecomservics/presentation/screens/transaction_detail_screen.dart';
import 'package:ecomservics/presentation/screens/favorites_screen.dart';
import 'package:ecomservics/presentation/screens/profile_screen.dart';
import 'package:ecomservics/presentation/screens/settings_screen.dart';
import 'package:ecomservics/presentation/screens/about_app_screen.dart';
import 'package:ecomservics/presentation/screens/legal_privacy_screen.dart';
import 'package:ecomservics/presentation/screens/refund_policy_screen.dart';
import 'package:ecomservics/presentation/screens/terms_services_screen.dart';
import 'package:ecomservics/presentation/screens/all_categories_screen.dart';
import 'package:ecomservics/presentation/screens/all_products_screen.dart';
import 'package:ecomservics/presentation/screens/product_detail_screen.dart';

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
    GoRoute(
      path: AppRoutes.signup,
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.otp,
      builder: (context, state) => const OtpScreen(),
    ),
    GoRoute(
      path: AppRoutes.checkout,
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      path: AppRoutes.orderSuccess,
      builder: (context, state) => const OrderSuccessScreen(),
    ),
    GoRoute(
      path: AppRoutes.orderHistory,
      builder: (context, state) => const OrderHistoryScreen(),
    ),
    GoRoute(
      path: AppRoutes.transactionList,
      builder: (context, state) => const TransactionListScreen(),
    ),
    GoRoute(
      path: AppRoutes.transactionDetail,
      builder: (context, state) => const TransactionDetailScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.about,
      builder: (context, state) => const AboutAppScreen(),
    ),
    GoRoute(
      path: AppRoutes.legal,
      builder: (context, state) => const LegalPrivacyScreen(),
    ),
    GoRoute(
      path: AppRoutes.refund,
      builder: (context, state) => const RefundPolicyScreen(),
    ),
    GoRoute(
      path: AppRoutes.terms,
      builder: (context, state) => const TermsServicesScreen(),
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
                GoRoute(
                  path: 'categories',
                  builder: (context, state) => const AllCategoriesScreen(),
                ),
                GoRoute(
                  path: 'products',
                  builder: (context, state) {
                    final categoryId = state.uri.queryParameters['categoryId'];
                    final categoryName = state.uri.queryParameters['categoryName'];
                    return AllProductsScreen(categoryId: categoryId, categoryName: categoryName);
                  },
                ),
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
              path: '/favorites',
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
      ],
    ),
  ],
);
