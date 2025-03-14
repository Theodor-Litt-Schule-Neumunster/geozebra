import 'package:flutter/material.dart';
import 'package:geozebra_app/models/theme_model.dart';

class LightTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.white,
      colorScheme: const ColorScheme.light(
        primary: Colors.white,
        onPrimary: Colors.black87,
        secondary: Colors.blueGrey,
        onSecondary: Color.fromARGB(221, 200, 200, 200),
        surface: Color.fromARGB(255, 245, 245, 245),
        onSurface: Colors.black87,
        error: Color(0xFFB00020),
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
      ),
      textTheme: const TextTheme(
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
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color.fromARGB(255, 240, 240, 240),
        selectedItemColor: Colors.black87,
        unselectedItemColor: Colors.black54,
        elevation: 5,
        selectedIconTheme: IconThemeData(
          size: 28,
        ),
        unselectedIconTheme: IconThemeData(
          size: 24,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 230, 230, 230),
          foregroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
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
      cardTheme: const CardTheme(
        color: Color(0xFFF5F5F5),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
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