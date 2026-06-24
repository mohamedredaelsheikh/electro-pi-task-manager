import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router/app_router.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final selectedIndex = location.startsWith(AppRoutes.settings)
        ? 2
        : location.startsWith(AppRoutes.profile)
            ? 1
            : 0;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shadowColor: const Color(0x14191C1E),
        elevation: 1,
        indicatorColor: const Color(0xFFE5E2FF),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go(AppRoutes.projects);
            case 1:
              context.go(AppRoutes.profile);
            case 2:
              context.go(AppRoutes.settings);
          }
        },
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
