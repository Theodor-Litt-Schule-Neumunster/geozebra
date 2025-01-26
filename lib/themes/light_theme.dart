import 'package:flutter/material.dart';

class LightTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.white, // White primary color
      colorScheme: const ColorScheme.light(
        primary: Colors.white, // White as the primary color
        onPrimary: Colors.black, // Black text/icons on primary
        secondary: Colors.black12, // Subtle gray for accents
        onSecondary: Colors.black, // Text/icons on secondary
        background: Colors.white, // White background
        onBackground: Colors.black, // Text on background
        surface: Colors.white, // White surfaces (e.g., app bar, cards)
        onSurface: Colors.black, // Text/icons on surface
        error: Color(0xFFB00020), // Standard error red
        onError: Colors.white, // Text/icons on error
      ),
      scaffoldBackgroundColor: Colors.white, // Pure white background
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white, // White app bar
        elevation: 0, // Flat design with no shadow
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black, // Black text for contrast
        ),
        iconTheme: IconThemeData(
          color: Colors.black, // Black icons
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
          color: Colors.black, // Headings in black
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black, // Subheadings in black
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white, // White background
        selectedItemColor: Colors.black, // Black for active items
        unselectedItemColor: Colors.black54, // Gray for inactive items
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
          backgroundColor: Colors.black, // Black buttons
          foregroundColor: Colors.white, // White text
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Slightly rounded corners
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.black12), // Subtle gray border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.black, width: 2), // Black focused border
        ),
        labelStyle: TextStyle(color: Colors.black54),
        hintStyle: TextStyle(color: Colors.black38),
      ),
      cardTheme: const CardTheme(
        color: Colors.white,
        elevation: 1, // Minimal elevation
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }
}
