import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/projects/presentation/cubit/projects_cubit.dart';
import '../../features/projects/presentation/pages/projects_page.dart';
import '../../features/tasks/presentation/cubit/tasks_cubit.dart';
import '../../features/tasks/presentation/pages/project_details_page.dart';
import '../di/injection.dart';
import '../widgets/main_shell.dart';
import 'go_router_refresh_stream.dart';

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
  refreshListenable: GoRouterRefreshStream(sl<AuthCubit>().stream),
  redirect: (context, state) {
    final authState = context.read<AuthCubit>().state;
    final isOnAuthRoute = state.matchedLocation == AppRoutes.login ||
        state.matchedLocation == AppRoutes.register;

    if (authState is AuthAuthenticated && isOnAuthRoute) {
      return AppRoutes.projects;
    }
    if (authState is! AuthAuthenticated && !isOnAuthRoute) {
      return AppRoutes.login;
    }
    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (_, _) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (_, _) => const RegisterPage(),
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
          builder: (_, _) => BlocProvider(
            create: (_) => sl<ProfileCubit>()..loadProfile(),
            child: const ProfilePage(),
          ),
        ),
      ],
    ),
    // Project details — full-screen, outside the shell
    GoRoute(
      path: AppRoutes.projectDetails,
      builder: (_, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
        final title = (state.extra as String?) ?? 'Project #$id';
        return BlocProvider(
          create: (_) => sl<TasksCubit>(param1: id)..loadTasks(),
          child: ProjectDetailsPage(projectId: id, projectTitle: title),
        );
      },
    ),
  ],
);
