import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (i) => navigationShell.goBranch(i, initialLocation: i == navigationShell.currentIndex),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.sports_esports), label: 'Main'),
          NavigationDestination(icon: Icon(Icons.menu_book), label: 'Belajar'),
          NavigationDestination(icon: Icon(Icons.military_tech), label: 'Pencapaian'),
          NavigationDestination(icon: Icon(Icons.account_circle), label: 'Profil'),
        ],
      ),
    );
  }
}
