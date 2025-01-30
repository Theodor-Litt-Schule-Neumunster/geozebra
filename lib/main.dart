import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geozebra_app/screens/home_screen.dart';
import 'package:geozebra_app/providers/theme_provider.dart';
import 'package:geozebra_app/services/async_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String savedTheme = await SettingsService.loadSetting<String>("theme", "light");
  runApp(MyApp(savedTheme: savedTheme));
}

class MyApp extends StatelessWidget {
  final String savedTheme;

  const MyApp({super.key, 
  required this.savedTheme
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider()..setTheme(savedTheme),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: "GeoZebra",
            debugShowCheckedModeBanner: false,
            theme: themeProvider.theme,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
