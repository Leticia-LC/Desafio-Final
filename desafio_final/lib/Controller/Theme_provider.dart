import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _themeKey = 'themeKey';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  late SharedPreferences _prefs;

  ThemeProvider() {
    _initPreferences();
  }

  ThemeMode get themeMode => _themeMode;

  Future<void> _initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadTheme();
  }

  void _loadTheme() {
    String? themeString = _prefs.getString(_themeKey);

    if (themeString != null) {
      _themeMode = ThemeMode.values.firstWhere(
            (element) => element.toString() == themeString,
        orElse: () => ThemeMode.system,
      );
    }

    notifyListeners();
  }

  void setTheme(ThemeMode themeMode) {
    _themeMode = themeMode;
    _prefs.setString(_themeKey, themeMode.toString());
    notifyListeners();
  }
}
