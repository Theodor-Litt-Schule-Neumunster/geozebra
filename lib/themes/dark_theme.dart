import 'package:flutter/material.dart';

class DarkTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.black, // Black primary color
      colorScheme: const ColorScheme.dark(
        primary: Colors.black, // Black as the primary color
        onPrimary: Colors.white70, // White text/icons on primary
        secondary: Colors.grey, // Gray for accents
        onSecondary: Colors.white70, // Text on secondary background
        surface: Color.fromARGB(255, 12, 12, 12), // Black surfaces (e.g., app bar, cards)
        onSurface: Colors.white70, // Text/icons on surface
        error: Color(0xFFCF6679), // Standard error red for dark themes
        onError: Colors.black, // Text/icons on error
      ),
      scaffoldBackgroundColor: Colors.black, // Pure black background
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black, // Black app bar
        elevation: 0, // Flat design with no shadow
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white70, // White text for contrast
        ),
        iconTheme: IconThemeData(
          color: Colors.white70, // White icons
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.white70, // Softer white for readability
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.white70, // Softer white for readability
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white70, // Headings in white
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white70, // Subheadings in white
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color.fromARGB(255, 33, 33, 33), // Dark gray background
        selectedItemColor: Colors.white70, // White for active items
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
          backgroundColor: Colors.white, // White buttons
          foregroundColor: Colors.black, // Black text
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Slightly rounded corners
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF212121), // Dark gray fill color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.white24), // Subtle white border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.white, width: 2), // White focused border
        ),
        labelStyle: TextStyle(color: Colors.white54),
        hintStyle: TextStyle(color: Colors.white38),
      ),
      cardTheme: const CardTheme(
        color: Color(0xFF212121), // Dark gray cards
        elevation: 1, // Minimal elevation
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }
}
