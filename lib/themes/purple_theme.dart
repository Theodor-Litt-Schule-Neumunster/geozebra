import 'package:flutter/material.dart';

class LightPurpleTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFF9C27B0), // Lila Hauptfarbe
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF9C27B0), // Lila Primärfarbe
        onPrimary: Colors.white, // Text/Icon-Farbe auf Primärfarbe
        secondary: Color(0xFFE1BEE7), // Helles Lila für Sekundärfarbe
        onSecondary: Colors.black, // Text/Icon-Farbe auf Sekundärfarbe
        surface: Color(0xFFF3E5F5), // Sehr helles Lila für Hintergrund
        onSurface: Colors.black, // Textfarbe auf Hintergrund
        error: Color(0xFFD32F2F), // Kräftiges Rot für Fehler
        onError: Colors.white, // Text/Icon-Farbe auf Fehlerfarbe
      ),
      scaffoldBackgroundColor: const Color(0xFFF3E5F5), // Heller lila Hintergrund
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF7B1FA2), // Dunkleres Lila für AppBar
        elevation: 3,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // AppBar Icons
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
          backgroundColor: const Color(0xFF7B1FA2), // Dunkleres Lila
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Color(0xFF9C27B0)), // Lila Randfarbe
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Color(0xFF7B1FA2), width: 2), // Stärkerer Rand bei Fokus
        ),
        labelStyle: TextStyle(color: Color(0xFF7B1FA2)),
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
