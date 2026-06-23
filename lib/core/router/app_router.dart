import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/projects/presentation/cubit/projects_cubit.dart';
import '../../features/projects/presentation/pages/projects_page.dart';
import '../di/injection.dart';
import '../widgets/main_shell.dart';

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
    ShellRoute(
      builder: (_, _, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.projects,
          builder: (_, _) => BlocProvider(
            create: (_) => sl<ProjectsCubit>()..loadProjects(),
            child: const ProjectsPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.profile,
          builder: (_, _) => const ProfilePage(),
        ),
      ],
    ),
    // Project details — full-screen, outside the shell (tasks feature fills this)
    GoRoute(
      path: AppRoutes.projectDetails,
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
        return _ProjectDetailsPlaceholder(projectId: id);
      },
    ),
  ],
);

// Temporary placeholder — replaced when the tasks feature lands.
class _ProjectDetailsPlaceholder extends StatelessWidget {
  final int projectId;
  const _ProjectDetailsPlaceholder({required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Project #$projectId')),
      body: const Center(child: Text('Tasks — coming soon')),
    );
  }
}
