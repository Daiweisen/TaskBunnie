import 'package:flutter/material.dart';

class AppTheme {
  static const Color _primaryDark = Color(0xff0D0C0C);
  static const Color _surfaceDark = Color(0xff343434);
  static const Color _onPrimary = Colors.white;
  
  static const Color priorityLow = Color(0xff2196F3);
  static const Color priorityMedium = Color(0xff4CC83C);
  static const Color priorityHigh = Colors.pink;
  static const Color priorityAll = Colors.orange;
  static const Color accent = Colors.deepPurple;

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: _primaryDark,
        surface: _surfaceDark,
        onPrimary: _onPrimary,
        onSurface: _onPrimary,
      ),
      scaffoldBackgroundColor: _primaryDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: _surfaceDark,
        foregroundColor: _onPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: _onPrimary,
      ),
      cardTheme: CardThemeData(
        color: accent,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _onPrimary.withOpacity(0.1),
        hintStyle: TextStyle(color: _onPrimary.withOpacity(0.7)),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 20.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: _onPrimary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: _onPrimary, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: _onPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _onPrimary,
          foregroundColor: accent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: const TextStyle(color: _onPrimary),
        menuStyle: MenuStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: accent.withOpacity(0.1),
        contentTextStyle: const TextStyle(color: accent),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: accent),
        ),
        behavior: SnackBarBehavior.floating,
        width: 350,
      ),
    );
  }

  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return priorityLow;
      case 'medium':
        return priorityMedium;
      case 'high':
        return priorityHigh;
      default:
        return priorityLow;
    }
  }
}