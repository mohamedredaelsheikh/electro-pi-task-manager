import 'package:flutter/material.dart';

class AppColors {
  final bool isDark;

  AppColors.light({this.isDark = false});
  AppColors.dark({this.isDark = true});

  Color get primary =>
      isDark
          ? throw UnsupportedError("Dark mode not supported")
          : const Color(0xff22CE6C);

  /// intro screen background color 0F1925
  Color get onPrimaryContainer =>
      isDark
          ? throw UnsupportedError("Dark mode not supported")
          : const Color(0xff0F1925);

  /// second counter color 22CE6C
  Color get primaryFixed =>
      isDark
          ? throw UnsupportedError("Dark mode not supported")
          : const Color(0xff22CE6C);

  /// dark border color D4D4D4
  Color get onSurfaceVariant =>
      isDark
          ? throw UnsupportedError("Dark mode not supported")
          : const Color(0xffD4D4D4);

  /// hint text color 737373
  Color get outline =>
      isDark
          ? throw UnsupportedError("Dark mode not supported")
          : const Color(0xff737373);

  /// text color 171717
  Color get onSurface =>
      isDark
          ? throw UnsupportedError("Dark mode not supported")
          : const Color(0xff171717);

  /// text color 2nd 404040
  Color get outlineVariant =>
      isDark
          ? throw UnsupportedError("Dark mode not supported")
          : const Color(0xff404040);

  /// text dark
  Color get onSecondaryContainer =>
      isDark
          ? throw UnsupportedError("Dark mode not supported")
          : const Color(0xff222B45);

  /// secondary button border color EAECF0
  Color get secondary =>
      isDark
          ? throw UnsupportedError("Dark mode not supported")
          : const Color(0xffEAECF0);

  /// secondary button background color FAFAFA
  Color get secondaryContainer =>
      isDark
          ? throw UnsupportedError("Dark mode not supported")
          : const Color(0xffFAFAFA);

  /// background color
  Color get surface =>
      isDark
          ? throw UnsupportedError("Dark mode not supported")
          : const Color(0xffFAFAFA);

  /// inverse surface color
  Color get inverseSurface =>
      isDark
          ? throw UnsupportedError("Dark mode not supported")
          : const Color(0xff000000);

  /// dim surface color
  Color get surfaceDim =>
      isDark
          ? throw UnsupportedError("Dark mode not supported")
          : const Color(0xffD9D9D9);

  /// bright card color
  Color get surfaceBright =>
      isDark
          ? throw UnsupportedError("Dark mode not supported")
          : const Color(0xffF5F5F5);

  /// clickable text color
  Color get tertiary =>
      isDark
          ? throw UnsupportedError("Dark mode not supported")
          : const Color(0xFFFC7D5D);

  /// selected button Splash color
  Color get primaryContainer =>
      isDark
          ? throw UnsupportedError("Dark mode not supported")
          : const Color(0xff386F1D);

  /// logout button color
  Color get tertiaryContainer =>
      isDark
          ? throw UnsupportedError("Dark mode not supported")
          : const Color(0xffFDF5F4);

  /// additional constant-only accessors
  Color get onTertiaryContainer =>
      isDark
          ? throw UnsupportedError("Dark mode not supported")
          : const Color(0xffff0000);
}
