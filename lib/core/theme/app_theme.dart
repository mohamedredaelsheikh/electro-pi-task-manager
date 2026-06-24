import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const _primaryColor = Color(0xFF4F46E5);
  static const _errorColor = Color(0xFFBA1A1A);

  static InputDecorationTheme _inputTheme({
    required Color fill,
    required Color border,
    required Color focused,
    required Color error,
    required Color hint,
    required Color icon,
  }) =>
      InputDecorationTheme(
        filled: true,
        fillColor: fill,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TextStyle(color: hint, fontSize: 14),
        prefixIconColor: icon,
        suffixIconColor: icon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: focused, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: error, width: 1.5),
        ),
        errorStyle: TextStyle(
          color: error,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      );

  static FilledButtonThemeData get _buttonTheme => FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primaryColor,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        inputDecorationTheme: _inputTheme(
          fill: Colors.white,
          border: const Color(0xFFDDDBF0),
          focused: _primaryColor,
          error: _errorColor,
          hint: const Color(0xFFB0ADCA),
          icon: const Color(0xFF777587),
        ),
        filledButtonTheme: _buttonTheme,
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primaryColor,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade800),
          ),
        ),
        inputDecorationTheme: _inputTheme(
          fill: const Color(0xFF2D2C3E),
          border: const Color(0xFF4A4860),
          focused: const Color(0xFF9D97F5),
          error: const Color(0xFFFFB4AB),
          hint: const Color(0xFF6B6880),
          icon: const Color(0xFF9994B0),
        ),
        filledButtonTheme: _buttonTheme,
      );
}
