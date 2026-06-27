import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'page_transitions.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/projects/presentation/cubit/projects_cubit.dart';
import '../../features/projects/presentation/pages/projects_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/tasks/presentation/cubit/tasks_cubit.dart';
import '../../features/tasks/presentation/pages/project_details_page.dart';
import '../di/injection.dart';
import '../widgets/main_shell.dart';
import 'go_router_refresh_stream.dart';

abstract class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const projects = '/projects';
  static const projectDetails = '/projects/:id';
  static const profile = '/profile';
  static const settings = '/settings';

  static String projectDetailsPath(int id) => '/projects/$id';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  refreshListenable: GoRouterRefreshStream(sl<AuthCubit>().stream),
  redirect: (context, state) {
    if (state.matchedLocation == AppRoutes.splash) return null;

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
      path: AppRoutes.splash,
      pageBuilder: (_, state) =>
          fadePage(pageKey: state.pageKey, child: const SplashPage()),
    ),
    GoRoute(
      path: AppRoutes.login,
      pageBuilder: (_, state) =>
          slideRightPage(pageKey: state.pageKey, child: const LoginPage()),
    ),
    GoRoute(
      path: AppRoutes.register,
      pageBuilder: (_, state) =>
          slideRightPage(pageKey: state.pageKey, child: const RegisterPage()),
    ),
    StatefulShellRoute.indexedStack(
      builder: (_, _, shell) => MainShell(navigationShell: shell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.projects,
            builder: (_, _) => BlocProvider(
              create: (_) => sl<ProjectsCubit>()..loadProjects(),
              child: const ProjectsPage(),
            ),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.profile,
            builder: (_, _) => BlocProvider(
              create: (_) => sl<ProfileCubit>()..loadProfile(),
              child: const ProfilePage(),
            ),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.settings,
            builder: (_, _) => const SettingsPage(),
          ),
        ]),
      ],
    ),
    // Project details — full-screen, outside the shell
    GoRoute(
      path: AppRoutes.projectDetails,
      pageBuilder: (_, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
        final title = (state.extra as String?) ?? 'Project #$id';
        return slideUpPage(
          pageKey: state.pageKey,
          child: BlocProvider(
            create: (_) => sl<TasksCubit>(param1: id)..loadTasks(),
            child: ProjectDetailsPage(projectId: id, projectTitle: title),
          ),
        );
      },
    ),
  ],
);
