import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geozebra_app/screens/home_screen.dart';
import 'package:geozebra_app/providers/settings_provider.dart';
import 'package:geozebra_app/services/settings_service.dart';
import 'package:geozebra_app/providers/notifications_provider.dart';
import 'package:flutter/services.dart';

// import 'screens/lesson_screen.dart';
// import 'screens/rechner_screen.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);  // Add this
    String savedTheme = await SettingsService().getValue<String>("theme", "light");
    await NotificationsProvider().initialize();
    runApp(MyApp(savedTheme: savedTheme));
  } catch (e) {
    print('Initialization error: $e');
    // Provide a fallback
    runApp(const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('App failed to initialize'),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  final String savedTheme;

  const MyApp({super.key, required this.savedTheme});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()..setTheme(savedTheme)),
      ],

      child: Consumer<SettingsProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: "GeoZebra",
            debugShowCheckedModeBanner: false,
            theme: themeProvider.theme,
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}


// YT: https://www.youtube.com/watch?v=uKz8tWbMuUw