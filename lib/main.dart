import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geozebra_app/screens/home_screen.dart';
import 'package:geozebra_app/providers/settings_provider.dart';
import 'package:geozebra_app/services/settings_service.dart';
import "package:geozebra_app/screens/test.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String savedTheme = await SettingsService().getValue<String>("theme", "light");
  runApp(MyApp(savedTheme: savedTheme));
}

class MyApp extends StatelessWidget {
  final String savedTheme;

  const MyApp({super.key, required this.savedTheme});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsProvider()..setTheme(savedTheme),
      child: Consumer<SettingsProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: "GeoZebra",
            debugShowCheckedModeBanner: false,
            theme: themeProvider.theme,
            home: StepperExample(),
          );
        },
      ),
    );
  }
}
