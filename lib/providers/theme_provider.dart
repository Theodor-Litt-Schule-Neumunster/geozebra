import 'package:flutter/material.dart';
import 'package:geozebra_app/themes/light_theme.dart';
import 'package:geozebra_app/themes/lightcolor_theme.dart';
import 'package:geozebra_app/themes/dark_theme.dart';
import 'package:geozebra_app/services/async_service.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _theme = LightTheme.theme;
  ThemeData get theme => _theme;

  void setTheme(String themeKey) {
    SettingsService.saveSetting("theme", themeKey);
    _setThemeFromKey(themeKey, notify: true);
  }

  void _setThemeFromKey(String themeKey, {bool notify = true}) {
    if (themeKey == "light") {
      _theme = LightTheme.theme;
    } else if (themeKey == "lightColor") {
      _theme = LightColorTheme.theme;
    } else if (themeKey == "dark") {
      _theme = DarkTheme.theme;
    }

    if (notify) {
      notifyListeners();
    }
  }
}
