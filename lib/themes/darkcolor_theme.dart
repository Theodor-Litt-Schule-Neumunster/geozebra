import 'package:flutter/material.dart';

class DarkColorTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Color(0xFF6A5AE0), // Purple primary color
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF6A5AE0), // Purple as the primary color
        onPrimary: Colors.white, // White text/icons on primary
        secondary: Color(0xFF8E8E93), // Gray for accents
        onSecondary: Colors.white, // Text on secondary background
        surface: Color.fromARGB(255, 31, 31, 31), // Dark gray surfaces
        onSurface: Colors.white, // White text/icons on surface
        error: Color(0xFFCF6679), // Standard error red for dark themes
        onError: Colors.black, // Text/icons on error
      ),
      scaffoldBackgroundColor: Color.fromARGB(255, 25, 25, 25), // Dark background
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 25, 25, 25), // Dark gray app bar
        elevation: 0, // Flat design with no shadow
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white, // White text for contrast
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // White icons
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.white, // White for readability
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.white, // White for readability
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Headings in white
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Subheadings in white
        )
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1C1C1E), // Dark gray background
        selectedItemColor: Color(0xFF6A5AE0), // Purple for active items
        unselectedItemColor: Colors.white54, // Softer white for inactive items
        elevation: 5, // Subtle shadow for separation
        selectedIconTheme: IconThemeData(
          size: 28, // Larger size for selected icon
        ),
        unselectedIconTheme: IconThemeData(
          size: 24, // Standard size for unselected icons
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF6A5AE0), // Purple buttons
          foregroundColor: Colors.white, // White text
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF2C2C2E), // Dark gray fill color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Color(0xFF6A5AE0)), // Purple border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Color(0xFF6A5AE0), width: 2), // Purple focused border
        ),
        labelStyle: TextStyle(color: Colors.white70),
        hintStyle: TextStyle(color: Colors.white54),
      ),
      cardTheme: const CardTheme(
        color: Color(0xFF2C2C2E), // Dark gray cards
        elevation: 2, // Minimal elevation
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }
}
