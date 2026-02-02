import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecomservics/generated/app_localizations.dart';
import 'package:ecomservics/presentation/blocs/cart_bloc.dart';

class MainScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({super.key, required this.navigationShell});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  void _onDestinationSelected(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
          final cartItemCount = cartState.items.length;
          
          return NavigationBar(
            selectedIndex: widget.navigationShell.currentIndex,
            onDestinationSelected: _onDestinationSelected,
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.home_outlined, color: widget.navigationShell.currentIndex == 0 ? Theme.of(context).primaryColor : Colors.grey),
                selectedIcon: Icon(Icons.home, color: Theme.of(context).primaryColor),
                label: l10n.home,
              ),
              NavigationDestination(
                icon: _CartIconWithBadge(
                  count: cartItemCount,
                  isSelected: widget.navigationShell.currentIndex == 1,
                ),
                selectedIcon: _CartIconWithBadge(
                  count: cartItemCount,
                  isSelected: true,
                ),
                label: l10n.cart,
              ),
              NavigationDestination(
                icon: Icon(Icons.favorite_outline, color: widget.navigationShell.currentIndex == 2 ? Theme.of(context).primaryColor : Colors.grey),
                selectedIcon: Icon(Icons.favorite, color: Theme.of(context).primaryColor),
                label: l10n.favorites,
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline, color: widget.navigationShell.currentIndex == 3 ? Theme.of(context).primaryColor : Colors.grey),
                selectedIcon: Icon(Icons.person, color: Theme.of(context).primaryColor),
                label: 'Profile',
              )
            ],
          );
        },
      ),
    );
  }
}

class _CartIconWithBadge extends StatelessWidget {
  final int count;
  final bool isSelected;

  const _CartIconWithBadge({
    required this.count,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          isSelected ? Icons.shopping_cart : Icons.shopping_cart_outlined,
          color: isSelected ? theme.primaryColor : Colors.grey,
        ),
        if (count > 0)
          Positioned(
            right: -6,
            top: -4,
            child: Container(
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                count > 99 ? '99+' : count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
