import 'package:flutter/material.dart';
import 'package:geozebra_app/models/theme_model.dart';

class LightBlueTheme {
  static ThemeData get theme {
    const primaryColor = Color.fromARGB(255, 33, 150, 243);
    const secondaryColor = Color(0xFFFFA000);
    const surfaceColor = Color(0xFFF5F5F5);
    const backgroundColor = Color(0xFFFFFFFF);
    const errorColor = Color(0xFFB00020);

    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: primaryColor,
        onPrimary: Colors.black,
        secondary: secondaryColor,
        onSecondary: Colors.white,
        error: errorColor,
        onError: Colors.white,
        background: backgroundColor,
        onBackground: Colors.black87,
        surface: surfaceColor,
        onSurface: Colors.black87,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor.withOpacity(0.8),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.black87,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.black87,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: Colors.black54,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.black54,
        elevation: 5,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.black26),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.black54, width: 2),
        ),
        labelStyle: TextStyle(color: Colors.black54),
        hintStyle: TextStyle(color: Colors.black38),
      ),
      extensions: [
        const TaskColors(
          uncompletedTask: Color.fromARGB(255, 230, 230, 230),
          completedTask: Color.fromARGB(255, 200, 220, 200),
        ),
      ],
    );
  }
}
