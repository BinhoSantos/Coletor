import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkMode extends ChangeNotifier {
  static DarkMode instance = DarkMode();

  late bool isDarkTheme;

  changeTheme() {
    isDarkTheme = !isDarkTheme;
    SharedPrefsDarkMode(isDarkTheme);
    notifyListeners();
  }

  Future<void> SharedPrefsDarkMode(bool tema) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("DarkMode", tema);
    var teste = prefs.getBool("DarkMode");
    print(teste);
  }
}
