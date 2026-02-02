import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomservics/generated/app_localizations.dart';

class MainScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({super.key, required this.navigationShell});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    // final l10n = AppLocalizations.of(context)!; // Using hardcoded labels to match design exactly for now
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
        backgroundColor: Theme.of(context).cardColor.withOpacity(0.9),
        indicatorColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        height: 65,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: widget.navigationShell.currentIndex == 0 ? Theme.of(context).primaryColor : Colors.grey),
            selectedIcon: Icon(Icons.home, color: Theme.of(context).primaryColor),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined, color: widget.navigationShell.currentIndex == 1 ? Theme.of(context).primaryColor : Colors.grey),
            selectedIcon: Icon(Icons.shopping_cart, color: Theme.of(context).primaryColor),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline, color: widget.navigationShell.currentIndex == 2 ? Theme.of(context).primaryColor : Colors.grey),
            selectedIcon: Icon(Icons.favorite, color: Theme.of(context).primaryColor),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: widget.navigationShell.currentIndex == 3 ? Theme.of(context).primaryColor : Colors.grey),
            selectedIcon: Icon(Icons.person, color: Theme.of(context).primaryColor),
            label: 'Profile',
          )
      
        ],
      ),
    );
  }
}
