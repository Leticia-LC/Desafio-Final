import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _themeKey = 'themeKey';
/// Provedor de tema
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  late SharedPreferences _prefs;
  /// Construtor que inicializa as preferências de tema
  ThemeProvider() {
    _initPreferences();
  }
  /// Obtém o modo de tema atual
  ThemeMode get themeMode => _themeMode;
  /// Inicializa as preferências de `SharedPreferences`
  Future<void> _initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadTheme();
  }
  /// Carrega o tema armazenado nas preferências
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
  /// Define um novo tema e persiste a preferência do usuário
  void setTheme(ThemeMode themeMode) {
    _themeMode = themeMode;
    _prefs.setString(_themeKey, themeMode.toString());
    notifyListeners();
  }
}
