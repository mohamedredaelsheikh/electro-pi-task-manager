import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

var thumbRadius = 16.w;
final appColors = AppColors.light();
ThemeData get lightTheme {
  // final appColors = AppColors.light();
  return ThemeData(
    scaffoldBackgroundColor: appColors.surface,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      shape: LinearBorder(
        side: BorderSide(color: appColors.secondary, width: 1.r),
        bottom: const LinearBorderEdge(),
      ),
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
    colorScheme: ColorScheme.fromSeed(
      seedColor: appColors.primary,
      primaryFixed: appColors.primaryFixed,
      primaryContainer: appColors.primaryContainer,
      onPrimaryContainer: appColors.onPrimaryContainer,
      primary: appColors.primary,
      surface: appColors.surface,
      inverseSurface: appColors.inverseSurface,
      onSurface: appColors.onSurface,
      onSurfaceVariant: appColors.onSurfaceVariant,
      surfaceDim: appColors.surfaceDim,
      outline: appColors.outline,
      outlineVariant: appColors.outlineVariant,
      secondary: appColors.secondary,
      secondaryContainer: appColors.secondaryContainer,
      onSecondaryContainer: appColors.onSecondaryContainer,
      surfaceBright: appColors.surfaceBright,
      tertiary: appColors.tertiary,
      tertiaryContainer: appColors.tertiaryContainer,
      onTertiaryContainer: appColors.onTertiaryContainer,
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

ThemeData get darkTheme => ThemeData.dark(useMaterial3: true);

TextTheme get lightTextTheme => TextTheme(
  /// (44/600)
  displayLarge: GoogleFonts.inter(
    fontSize: 44.sp,
    fontWeight: FontWeight.w600,
    color: appColors.onSurface,
  ),

  /// (24/700)
  headlineLarge: GoogleFonts.inter(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    color: appColors.onSecondaryContainer,
  ),

  ///heading8 (20/600)
  headlineMedium: GoogleFonts.inter(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: appColors.onSurface,
  ),

  /// (16/600)
  headlineSmall: GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: appColors.onSurface,
  ),

  ///Xtra-Large (18/600)
  titleLarge: GoogleFonts.inter(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: appColors.onSurface,
    height: (26 / 18),
  ),

  ///large/Medium (16/500)
  titleMedium: GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: appColors.onSurface,
  ),

  ///medium/bold (14/600)
  bodyLarge: GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: appColors.outline,
  ),

  ///medium/medium (14/500)
  bodyMedium: GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: appColors.onSurface,
  ),

  ///medium regular (14/400)
  bodySmall: GoogleFonts.inter(fontSize: 14.sp, color: appColors.outline),

  ///(12/500)
  labelMedium: GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: appColors.inverseSurface,
  ),
  labelSmall: GoogleFonts.inter(
    fontSize: 10.sp,
    fontWeight: FontWeight.w600,
    color: const Color(0xff353535),
  ),
);
