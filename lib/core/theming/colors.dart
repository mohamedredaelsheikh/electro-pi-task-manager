import 'package:flutter/material.dart';

class AppColors {
  const AppColors();

  /// primary brand color
  Color get primary => const Color(0xff17275B);

  /// selected button splash color
  Color get primaryContainer => const Color(0xff2E437C);

  /// selected button highlight color
  Color get onPrimaryContainer => const Color(0xff17275B);

  /// intro screen background color
  Color get primaryFixed => const Color(0xff0F1B4C);

  Color get primaryFixedDim => const Color(0xFF42598C);

  /// default filled non-primary button background
  Color get secondary => const Color(0xff79AA49);

  /// text fields and icon button background color
  Color get secondaryContainer => const Color(0xff404040);

  /// color of icon in icon button
  Color get onSecondaryContainer => const Color(0xff292D32);

  /// disabled
  Color get secondaryFixed => const Color(0xffA3A3A3);

  /// clickable text color
  Color get tertiary => const Color(0xff0088AA);

  /// logout button color
  Color get tertiaryContainer => const Color(0xffFDF5E5);

  /// logout button icon/text color
  Color get onTertiaryContainer => const Color(0xffEDA202);

  Color get tertiaryFixed => const Color(0xffF7F4ED);
  Color get tertiaryFixedDim => const Color(0xffE9E4DA);

  /// background color
  Color get surface => Colors.white;

  /// bright card color
  Color get surfaceBright => const Color(0xffFAFAFA);

  /// primary text color
  Color get onSurface => const Color(0xff1B1C22);

  /// border color
  Color get onSurfaceVariant => const Color(0xffDDDDDD);

  /// dim surface color
  Color get surfaceDim => const Color(0xffDFDFDF);

  Color get surfaceContainer => const Color(0xffE5E5E5);

  Color get surfaceContainerLow => const Color(0xffF5F5F5);

  /// inverse surface color to get user attention
  Color get inverseSurface => const Color(0xffB734A3);

  /// hint text color
  Color get outline => const Color(0xff737373);

  /// divider color
  Color get outlineVariant => const Color(0xffF4FAF3);

  Color get errorContainer => const Color(0xffFDF5F4);
  Color get error => const Color(0xffDD321F);
}

class DarkAppColors extends AppColors {
  const DarkAppColors();

  @override
  Color get primary => const Color(0xff5B7DD4);

  @override
  Color get primaryContainer => const Color(0xff3A5AAE);

  @override
  Color get onPrimaryContainer => const Color(0xff5B7DD4);

  @override
  Color get primaryFixed => const Color(0xff243870);

  @override
  Color get primaryFixedDim => const Color(0xff3D5590);

  @override
  Color get secondary => const Color(0xff79AA49);

  @override
  Color get secondaryContainer => const Color(0xff2A2C3A);

  @override
  Color get onSecondaryContainer => const Color(0xffC5C7D8);

  @override
  Color get secondaryFixed => const Color(0xff5A5B6A);

  @override
  Color get tertiary => const Color(0xff40AACC);

  @override
  Color get tertiaryContainer => const Color(0xff1A2535);

  @override
  Color get onTertiaryContainer => const Color(0xffF0B84D);

  @override
  Color get tertiaryFixed => const Color(0xff1E2A3A);

  @override
  Color get tertiaryFixedDim => const Color(0xff283545);

  @override
  Color get surface => const Color(0xff0F1120);

  @override
  Color get surfaceBright => const Color(0xff1E2035);

  @override
  Color get onSurface => const Color(0xffE8E9F2);

  @override
  Color get onSurfaceVariant => const Color(0xff2E3048);

  @override
  Color get surfaceDim => const Color(0xff090A14);

  @override
  Color get surfaceContainer => const Color(0xff1A1C2E);

  @override
  Color get surfaceContainerLow => const Color(0xff141626);

  @override
  Color get inverseSurface => const Color(0xff5B7DD4);

  @override
  Color get outline => const Color(0xff8889A0);

  @override
  Color get outlineVariant => const Color(0xff1E2030);

  @override
  Color get errorContainer => const Color(0xff3D1515);

  @override
  Color get error => const Color(0xffFF5449);
}
