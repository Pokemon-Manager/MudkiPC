// ignore: implementation_imports
import 'package:flutter/src/material/app.dart';
import 'package:flutter/widgets.dart';

class ThemeManager extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  get themeMode => _themeMode;
  toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
