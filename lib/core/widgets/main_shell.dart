import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const MainShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shadowColor: const Color(0x14191C1E),
        elevation: 1,
        indicatorColor: const Color(0xFFE5E2FF),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.folder_outlined, color: Color(0xFF777587)),
            selectedIcon: Icon(Icons.folder_rounded, color: Color(0xFF3525CD)),
            label: 'Projects',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded, color: Color(0xFF777587)),
            selectedIcon: Icon(Icons.person_rounded, color: Color(0xFF3525CD)),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined, color: Color(0xFF777587)),
            selectedIcon:
                Icon(Icons.settings_rounded, color: Color(0xFF3525CD)),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
