import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

import 'core/di/injection.dart';
import 'core/language/app_localizations.dart';
import 'core/router/app_router.dart';
import 'core/theming/themes.dart';
import 'core/widgets/connectivity/offline_banner.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/Localization/presentation/logic/lang_cubit/lang_cubit.dart';
import 'features/Localization/presentation/logic/lang_cubit/lang_state.dart';
import 'features/settings/domain/enums/app_theme_mode.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'features/settings/presentation/cubit/settings_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthCubit>()..checkSession()),
        BlocProvider(create: (_) => sl<SettingsCubit>()),
        BlocProvider(create: (_) => sl<LangCubit>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(402, 874),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, settings) => BlocBuilder<LangCubit, LangState>(
            builder: (context, lang) => MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routerConfig: appRouter,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: switch (settings.themeMode) {
                AppThemeMode.light => ThemeMode.light,
                AppThemeMode.dark => ThemeMode.dark,
                AppThemeMode.system => ThemeMode.system,
              },
              locale: lang.locale,
              supportedLocales: S.supportedLocales,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              builder: (context, child) => ToastificationWrapper(
                child: OfflineBanner(child: child ?? const SizedBox()),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
