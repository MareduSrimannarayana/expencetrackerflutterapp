import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider =
    ChangeNotifierProvider<ThemeProvider>((ref) => ThemeProvider());

class ThemeProvider extends ChangeNotifier {
  ThemeData _selectedTheme = ThemeData.light();

  ThemeData get getTheme => _selectedTheme;

  Future<void> initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _selectedTheme = isDarkMode ? ThemeData.dark() : ThemeData.light();
    notifyListeners();
  }

  void toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_selectedTheme.brightness == Brightness.dark) {
      _selectedTheme = ThemeData.light();
      prefs.setBool('isDarkMode', false);
    } else {
      _selectedTheme = ThemeData.dark();
      prefs.setBool('isDarkMode', true);
    }
    notifyListeners();
  }
}
