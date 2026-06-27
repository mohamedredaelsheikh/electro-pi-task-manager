import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cache/hive_cache_client.dart';
import '../network/api_client.dart';
import '../storage/token_storage.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/check_auth_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/projects/data/datasources/projects_local_datasource.dart';
import '../../features/projects/data/datasources/projects_remote_datasource.dart';
import '../../features/projects/data/repositories/projects_repository_impl.dart';
import '../../features/projects/domain/repositories/projects_repository.dart';
import '../../features/projects/domain/usecases/get_projects_usecase.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_profile_usecase.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/projects/presentation/cubit/projects_cubit.dart';
import '../../features/tasks/data/datasources/tasks_local_datasource.dart';
import '../../features/tasks/data/datasources/tasks_remote_datasource.dart';
import '../../features/tasks/data/repositories/tasks_repository_impl.dart';
import '../../features/tasks/domain/repositories/tasks_repository.dart';
import '../../features/tasks/domain/usecases/create_task_usecase.dart';
import '../../features/tasks/domain/usecases/get_tasks_usecase.dart';
import '../../features/tasks/domain/usecases/update_task_status_usecase.dart';
import '../../features/tasks/presentation/cubit/tasks_cubit.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/usecases/get_locale_usecase.dart';
import '../../features/settings/domain/usecases/get_theme_mode_usecase.dart';
import '../../features/settings/domain/usecases/set_locale_usecase.dart';
import '../../features/settings/domain/usecases/set_theme_mode_usecase.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../features/Localization/data/services/lang_service.dart';
import '../../features/Localization/presentation/logic/lang_cubit/lang_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  // External
  await Hive.initFlutter();
  final cacheBox = await Hive.openBox<String>('app_cache_v2');
  final prefs = await SharedPreferences.getInstance();

  sl.registerSingleton<Box<String>>(cacheBox);
  sl.registerSingleton<SharedPreferences>(prefs);

  // Core
  sl.registerLazySingleton<ApiClient>(ApiClient.new);
  sl.registerLazySingleton<TokenStorage>(() => TokenStorage(sl()));
  sl.registerLazySingleton<HiveCacheClient>(() => HiveCacheClient(sl()));

  // Auth — data
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );

  // Auth — domain
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthUseCase(sl()));

  // Auth — presentation (singleton so the router and widget tree share one instance)
  sl.registerLazySingleton(
    () => AuthCubit(
      login: sl(),
      register: sl(),
      logout: sl(),
      checkAuth: sl(),
    ),
    dispose: (cubit) => cubit.close(),
  );

  // Profile — data
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );

  // Profile — domain
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));

  // Profile — presentation
  sl.registerFactory(() => ProfileCubit(sl()));

  // Projects — data
  sl.registerLazySingleton<ProjectsRemoteDataSource>(
    () => ProjectsRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<ProjectsLocalDataSource>(
    () => ProjectsLocalDataSource(sl()),
  );
  sl.registerLazySingleton<ProjectsRepository>(
    () => ProjectsRepositoryImpl(sl(), sl()),
  );

  // Projects — domain
  sl.registerLazySingleton(() => GetProjectsUseCase(sl()));

  // Projects — presentation (singleton so task updates propagate back to the project list)
  sl.registerLazySingleton(
    () => ProjectsCubit(sl()),
    dispose: (cubit) => cubit.close(),
  );

  // Tasks — data
  sl.registerLazySingleton<TasksRemoteDataSource>(
    () => TasksRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<TasksLocalDataSource>(
    () => TasksLocalDataSource(sl()),
  );
  sl.registerLazySingleton<TasksRepository>(
    () => TasksRepositoryImpl(sl(), sl()),
  );

  // Tasks — domain
  sl.registerLazySingleton(() => GetTasksUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTaskStatusUseCase(sl()));
  sl.registerLazySingleton(() => CreateTaskUseCase(sl()));

  // Tasks — presentation (factoryParam lets the router inject projectId at runtime)
  sl.registerFactoryParam<TasksCubit, int, void>(
    (projectId, _) => TasksCubit(
      projectId: projectId,
      getTasks: sl(),
      updateStatus: sl(),
      createTask: sl(),
      onStatusChanged: sl<ProjectsCubit>().updateProjectStatus,
    ),
  );

  // Settings — data
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(sl()),
  );

  // Settings — domain
  sl.registerLazySingleton(() => GetThemeModeUseCase(sl()));
  sl.registerLazySingleton(() => SetThemeModeUseCase(sl()));
  sl.registerLazySingleton(() => GetLocaleUseCase(sl()));
  sl.registerLazySingleton(() => SetLocaleUseCase(sl()));

  // Settings — presentation (singleton so theme/locale state is shared app-wide)
  sl.registerLazySingleton(
    () => SettingsCubit(
      getThemeMode: sl(),
      setThemeMode: sl(),
      getLocale: sl(),
      setLocale: sl(),
    ),
    dispose: (cubit) => cubit.close(),
  );

  // Localization — data
  sl.registerLazySingleton(() => LangService(prefs: sl()));

  // Localization — presentation (singleton so locale state is shared app-wide)
  sl.registerLazySingleton(
    () => LangCubit(langService: sl()),
    dispose: (cubit) => cubit.close(),
  );
}
