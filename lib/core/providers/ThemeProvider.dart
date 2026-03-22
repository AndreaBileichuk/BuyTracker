import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/AppTheme.dart';

class ThemeProvider extends ChangeNotifier {
  String _themeName = 'light';

  String get themeName => _themeName;

  bool get isDarkMode => _themeName == 'dark';

  ThemeData get currentTheme {
    switch (_themeName) {
      case 'dark': return AppTheme.darkTheme;
      case 'emerald': return AppTheme.emeraldTheme;
      case 'sunset': return AppTheme.sunsetTheme;
      case 'light':
      default: return AppTheme.lightTheme;
    }
  }

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('themeName');
    
    if (name != null) {
      _themeName = name;
    } else {
      // migration from old boolean logic
      final isDark = prefs.getBool('isDarkMode');
      if (isDark != null && isDark) {
        _themeName = 'dark';
      } else {
        _themeName = 'light';
      }
    }
    notifyListeners();
  }

  Future<void> setTheme(String name) async {
    _themeName = name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeName', name);
    // remove obsolete key
    await prefs.remove('isDarkMode');
    notifyListeners();
  }
}
