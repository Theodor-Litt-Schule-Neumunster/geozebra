import 'package:flutter/material.dart';

import 'package:geozebra_app/themes/light_theme.dart';
import 'package:geozebra_app/themes/lightblue_theme.dart';
import 'package:geozebra_app/themes/dark_theme.dart';
import 'package:geozebra_app/themes/darkcolor_theme.dart';
import 'package:geozebra_app/themes/purple_theme.dart';
import 'package:geozebra_app/themes/lightgreen_theme.dart';

import 'package:geozebra_app/services/settings_service.dart';

class SettingsProvider extends ChangeNotifier {
  ThemeData _theme = LightTheme.theme;
  ThemeData get theme => _theme;

  String _username = "";
  String get username => _username;

  Future<void> clearAllData() async {
    await SettingsService().clearAll();
    _username = "";
    _theme = LightTheme.theme;
    notifyListeners();
  }

  void setUsername(String username) {
    SettingsService().setValue("username", username);
    _username = username;
    notifyListeners();
  }

  void setTheme(String themeKey) {
    SettingsService().setValue("theme", themeKey);
    if (themeKey == "light") {
      _theme = LightTheme.theme;
    } else if (themeKey == "lightGreen") {
      _theme = LightGreenTheme.theme;
    } else if (themeKey == "lightBlue") {
      _theme = LightBlueTheme.theme;
    } else if (themeKey == "dark") {
      _theme = DarkTheme.theme;
    } else if (themeKey == "darkColor") {
      _theme = DarkColorTheme.theme;
    } else if (themeKey == "purple") {
      _theme = LightPurpleTheme.theme;
    } else {
      _theme = LightTheme.theme;
    }
    notifyListeners();
  }
}
