import 'package:flutter/material.dart';


import 'package:geozebra_app/screens/home_screen.dart';
import 'package:geozebra_app/screens/practice_screen.dart';

import "package:geozebra_app/themes/light_theme.dart";
import "package:geozebra_app/themes/lightcolor_theme.dart";
import "package:geozebra_app/themes/dark_theme.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geozebra',
      debugShowCheckedModeBanner: false,
      theme: DarkTheme.theme,
      home: const HomeScreen(),
    );
  }
}
