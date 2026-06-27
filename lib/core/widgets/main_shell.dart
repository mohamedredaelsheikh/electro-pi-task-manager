import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const MainShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        backgroundColor: colorScheme.surfaceBright,
        surfaceTintColor: Colors.transparent,
        shadowColor: const Color(0x14191C1E),
        elevation: 1,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.15),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.folder_outlined, color: colorScheme.outline),
            selectedIcon: Icon(Icons.folder_rounded, color: colorScheme.primary),
            label: 'Projects',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded, color: colorScheme.outline),
            selectedIcon: Icon(Icons.person_rounded, color: colorScheme.primary),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined, color: colorScheme.outline),
            selectedIcon: Icon(Icons.settings_rounded, color: colorScheme.primary),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
