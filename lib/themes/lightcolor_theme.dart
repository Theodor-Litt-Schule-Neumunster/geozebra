import 'package:flutter/material.dart';

class LightColorTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color.fromARGB(255, 0, 143, 219),
      colorScheme: const ColorScheme.light(
        primary: Color.fromARGB(255, 0, 141, 218),
        onPrimary: Colors.black, // Text/icon color on primary color
        secondary: Color(0xFF90E0EF), // Light cyan for secondary color
        onSecondary: Colors.black, // Text/icon color on secondary
        surface: Color(0xFFEFF6FF), // Very light blue for background
        onSurface: Colors.black, // Text color on background
        error: Color(0xFFEF476F), // Vibrant red for errors
        onError: Colors.white, // Text/icon color on error
      ),
      scaffoldBackgroundColor: const Color(0xFFEFF6FF), // Light blue background
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0077B6), // Deep blue for app bar
        elevation: 3, // Slight shadow for app bar
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // App bar icons
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontSize: 18,
          color: Colors.black87,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0077B6), // Deep blue
          foregroundColor: Colors.white, // Text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Slightly rounded corners
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Color(0xFF0077B6)), // Border color
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Color(0xFF0077B6), width: 2), // Focused border
        ),
        labelStyle: TextStyle(color: Color(0xFF0077B6)),
        hintStyle: TextStyle(color: Colors.black54),
      ),
      cardTheme: const CardTheme(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }
}
