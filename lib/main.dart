import 'package:flutter/material.dart';
import 'package:geozebra_app/screens/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geozebra',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
