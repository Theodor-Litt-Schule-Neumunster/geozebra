import 'package:flutter/material.dart';
import 'package:geozebra_app/themes/light_theme.dart';
import 'package:geozebra_app/themes/lightcolor_theme.dart';
import 'package:geozebra_app/themes/dark_theme.dart';
import 'package:geozebra_app/services/async_service.dart';

class SettingsProvider extends ChangeNotifier {
  ThemeData _theme = LightTheme.theme;
  ThemeData get theme => _theme;

  String _username = "";
  String get username => _username;



  void setUsername(String username) {
    SettingsService.saveSetting("username", username);
    _username = username;
    notifyListeners();
  }

  void setTheme(String themeKey) {
    SettingsService.saveSetting("theme", themeKey);
    if (themeKey == "light") {
      _theme = LightTheme.theme;
    } else if (themeKey == "lightColor") {
      _theme = LightColorTheme.theme;
    } else if (themeKey == "dark") {
      _theme = DarkTheme.theme;
    }
    notifyListeners();
  }
}
