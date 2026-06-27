import 'package:electro_pi_task_manager/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final appColors = const AppColors();
final darkAppColors = const DarkAppColors();
ThemeData get lightTheme {
  return ThemeData(
    scaffoldBackgroundColor: appColors.surface,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: appColors.surfaceContainerLow,
      foregroundColor: appColors.onSurface,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(11.r),
      hintStyle: lightTextTheme.bodySmall,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: appColors.secondary, width: 1.r),
      ),
      filled: true,
      fillColor: appColors.surface,
    ),
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return appColors.primary; // Active state
        }
        return appColors.surfaceContainer; // Inactive state
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return appColors.primary; // Active state
        }
        return appColors.surfaceContainer; // Inactive state
      }),
      thumbColor: WidgetStateProperty.all(appColors.surface),
      trackOutlineWidth: WidgetStateProperty.all(0),
      thumbIcon: WidgetStateProperty.all(
        Icon(Icons.circle, color: appColors.surface),
      ),
      padding: EdgeInsetsDirectional.zero,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: appColors.primary,
      primaryFixed: appColors.primaryFixed,
      primaryContainer: appColors.primaryContainer,
      onPrimaryContainer: appColors.onPrimaryContainer,
      primaryFixedDim: appColors.primaryFixedDim,
      primary: appColors.primary,
      surface: appColors.surface,
      inverseSurface: appColors.inverseSurface,
      error: appColors.error,
      errorContainer: appColors.errorContainer,
      onSurface: appColors.onSurface,
      onSurfaceVariant: appColors.onSurfaceVariant,
      surfaceDim: appColors.surfaceDim,
      outline: appColors.outline,
      outlineVariant: appColors.outlineVariant,
      secondary: appColors.secondary,
      secondaryContainer: appColors.secondaryContainer,
      onSecondaryContainer: appColors.onSecondaryContainer,
      secondaryFixed: appColors.secondaryFixed,
      surfaceBright: appColors.surfaceBright,
      surfaceContainer: appColors.surfaceContainer,
      surfaceContainerLow: appColors.surfaceContainerLow,
      tertiary: appColors.tertiary,
      tertiaryContainer: appColors.tertiaryContainer,
      onTertiaryContainer: appColors.onTertiaryContainer,
      tertiaryFixed: appColors.tertiaryFixed,
      tertiaryFixedDim: appColors.tertiaryFixedDim,
    ),
    useMaterial3: true,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: appColors.surface,
      elevation: 0,
      selectedItemColor: appColors.primary,
      unselectedItemColor: appColors.onSurface,
    ),
    textTheme: lightTextTheme,
  );
}

ThemeData get darkTheme {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkAppColors.surface,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: darkAppColors.surfaceContainerLow,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(11.r),
      hintStyle: darkTextTheme.bodySmall,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: darkAppColors.secondary, width: 1.r),
      ),
      filled: true,
      fillColor: darkAppColors.surfaceContainer,
    ),
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return darkAppColors.primary;
        }
        return darkAppColors.surfaceContainer;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return darkAppColors.primary;
        }
        return darkAppColors.surfaceContainer;
      }),
      thumbColor: WidgetStateProperty.all(darkAppColors.onSurface),
      trackOutlineWidth: WidgetStateProperty.all(0),
      thumbIcon: WidgetStateProperty.all(
        Icon(Icons.circle, color: darkAppColors.onSurface),
      ),
      padding: EdgeInsetsDirectional.zero,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: darkAppColors.primary,
      brightness: Brightness.dark,
      primaryFixed: darkAppColors.primaryFixed,
      primaryContainer: darkAppColors.primaryContainer,
      onPrimaryContainer: darkAppColors.onPrimaryContainer,
      primaryFixedDim: darkAppColors.primaryFixedDim,
      primary: darkAppColors.primary,
      surface: darkAppColors.surface,
      inverseSurface: darkAppColors.inverseSurface,
      error: darkAppColors.error,
      errorContainer: darkAppColors.errorContainer,
      onSurface: darkAppColors.onSurface,
      onSurfaceVariant: darkAppColors.onSurfaceVariant,
      surfaceDim: darkAppColors.surfaceDim,
      outline: darkAppColors.outline,
      outlineVariant: darkAppColors.outlineVariant,
      secondary: darkAppColors.secondary,
      secondaryContainer: darkAppColors.secondaryContainer,
      onSecondaryContainer: darkAppColors.onSecondaryContainer,
      secondaryFixed: darkAppColors.secondaryFixed,
      surfaceBright: darkAppColors.surfaceBright,
      surfaceContainer: darkAppColors.surfaceContainer,
      surfaceContainerLow: darkAppColors.surfaceContainerLow,
      tertiary: darkAppColors.tertiary,
      tertiaryContainer: darkAppColors.tertiaryContainer,
      onTertiaryContainer: darkAppColors.onTertiaryContainer,
      tertiaryFixed: darkAppColors.tertiaryFixed,
      tertiaryFixedDim: darkAppColors.tertiaryFixedDim,
    ),
    useMaterial3: true,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: darkAppColors.surfaceContainer,
      elevation: 0,
      selectedItemColor: darkAppColors.primary,
      unselectedItemColor: darkAppColors.outline,
    ),
    textTheme: darkTextTheme,
  );
}

/// Figma to Design Text System Mapping
/// display - display
/// title_regular - title
/// title_bold - headline
/// text_regular - label
/// text_semibold - body
/// text_bold - version of body accessed from extension
/// Caption - version of label accessed from extension
TextTheme get lightTextTheme => TextTheme(
  /// (52/400)
  displaySmall: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 52.sp,
    color: appColors.onSurface,
    fontWeight: FontWeight.w400, // adjust to Regular, Bold, etc.
  ),

  /// (52/700)
  displayLarge: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 52.sp,
    fontWeight: FontWeight.w700, // Bold
    color: appColors.onSurface,
  ),
  ////////////////////////////////////////////////////////////////////////////////////////
  /// (14/400)title_regular_small
  titleSmall: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14.sp,
    color: appColors.onSecondaryContainer,
    letterSpacing: 0.28,
    fontWeight: FontWeight.w400, // default Regular
  ),

  /// (16/400)title_regular_medium
  titleMedium: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 16.sp,
    color: appColors.onSecondaryContainer,
    letterSpacing: 0.32,
    fontWeight: FontWeight.w400, // Regular
  ),

  ///(20/400)title_regular_large
  titleLarge: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 20.sp,
    color: appColors.onSurface,
    letterSpacing: 0.4,
    fontWeight: FontWeight.w400, // Regular
  ),
  ////////////////////////////////////////////////////////////////////////////////////////

  ///(38/700)title_bold_small
  headlineSmall: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    color: appColors.onSurface,
    letterSpacing: 0.48,
  ),

  ///(16/700)title_bold_medium
  headlineMedium: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 30.sp,
    fontWeight: FontWeight.w700,
    color: appColors.onSurface,
    letterSpacing: 0.6,
  ),

  ///(18/700)title_bold_large
  headlineLarge: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 38.sp,
    fontWeight: FontWeight.w700,
    color: appColors.onSurface,
    letterSpacing: 0.76,
  ),

  ////////////////////////////////////////////////////////////////////////////////////////
  ///(14/400)text_regular_small
  labelSmall: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14.sp,
    color: appColors.tertiary,
    letterSpacing: 0.28,
  ),

  ///(16/400)text_regular_medium
  labelMedium: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 16.sp,
    color: appColors.outline,
    letterSpacing: 0.32,
  ),

  ///(20/400)text_regular_large
  labelLarge: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 20.sp,
    color: appColors.outline,
    letterSpacing: 0.4,
  ),
  ////////////////////////////////////////////////////////////////////////////////////////
  ///(14/600)text_semibold_small
  bodySmall: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: appColors.outline,
    letterSpacing: 0.28,
  ),

  ///(16/600)text_semibold_medium
  bodyMedium: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: appColors.outline,
    letterSpacing: 0.32,
  ),

  ///(20/600)text_semibold_large
  bodyLarge: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: appColors.onSurface,
    letterSpacing: 0.4,
  ),
);

TextTheme get darkTextTheme => TextTheme(
  displaySmall: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 52.sp,
    color: darkAppColors.onSurface,
    fontWeight: FontWeight.w400,
  ),
  displayLarge: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 52.sp,
    fontWeight: FontWeight.w700,
    color: darkAppColors.onSurface,
  ),
  titleSmall: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14.sp,
    color: darkAppColors.onSecondaryContainer,
    letterSpacing: 0.28,
    fontWeight: FontWeight.w400,
  ),
  titleMedium: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 16.sp,
    color: darkAppColors.onSecondaryContainer,
    letterSpacing: 0.32,
    fontWeight: FontWeight.w400,
  ),
  titleLarge: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 20.sp,
    color: darkAppColors.onSurface,
    letterSpacing: 0.4,
    fontWeight: FontWeight.w400,
  ),
  headlineSmall: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    color: darkAppColors.onSurface,
    letterSpacing: 0.48,
  ),
  headlineMedium: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 30.sp,
    fontWeight: FontWeight.w700,
    color: darkAppColors.onSurface,
    letterSpacing: 0.6,
  ),
  headlineLarge: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 38.sp,
    fontWeight: FontWeight.w700,
    color: darkAppColors.onSurface,
    letterSpacing: 0.76,
  ),
  labelSmall: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14.sp,
    color: darkAppColors.tertiary,
    letterSpacing: 0.28,
  ),
  labelMedium: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 16.sp,
    color: darkAppColors.outline,
    letterSpacing: 0.32,
  ),
  labelLarge: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 20.sp,
    color: darkAppColors.outline,
    letterSpacing: 0.4,
  ),
  bodySmall: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: darkAppColors.outline,
    letterSpacing: 0.28,
  ),
  bodyMedium: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: darkAppColors.outline,
    letterSpacing: 0.32,
  ),
  bodyLarge: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: darkAppColors.onSurface,
    letterSpacing: 0.4,
  ),
);
