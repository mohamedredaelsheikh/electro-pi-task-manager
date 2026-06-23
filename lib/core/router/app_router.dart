import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../di/injection.dart';

abstract class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const projects = '/projects';
  static const projectDetails = '/projects/:id';
  static const profile = '/profile';

  static String projectDetailsPath(int id) => '/projects/$id';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  redirect: (context, state) {
    final authState = context.read<AuthCubit>().state;
    final isOnAuthRoute = state.matchedLocation == AppRoutes.login ||
        state.matchedLocation == AppRoutes.register;

    if (authState is AuthAuthenticated && isOnAuthRoute) {
      return AppRoutes.projects;
    }
    if (authState is! AuthAuthenticated &&
        authState is! AuthInitial &&
        !isOnAuthRoute) {
      return AppRoutes.login;
    }
    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (_, _) => BlocProvider(
        create: (_) => sl<AuthCubit>()..checkSession(),
        child: const LoginPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (_, _) => BlocProvider.value(
        value: sl<AuthCubit>(),
        child: const RegisterPage(),
      ),
    ),
    // Placeholder routes — filled in by projects/tasks/profile features
    GoRoute(
      path: AppRoutes.projects,
      builder: (_, _) => const _PlaceholderPage(label: 'Projects'),
    ),
  ],
);

class _PlaceholderPage extends StatelessWidget {
  final String label;
  const _PlaceholderPage({required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(label)),
      body: Center(child: Text('$label — coming soon')),
    );
  }
}
