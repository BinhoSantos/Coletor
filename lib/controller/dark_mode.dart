import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkMode extends ChangeNotifier {
  //Change Notifier é uma espécie de SetState porém para a parte de código.

  static DarkMode instance =
      DarkMode(); // Instanciando a classe nela mesmo como estática.

  late bool isDarkTheme;

  changeTheme() {
    isDarkTheme = !isDarkTheme;
    SharedPrefsDarkMode(isDarkTheme);
    notifyListeners(); //Notifica a outra .dart.
  }

  Future<void> SharedPrefsDarkMode(bool x) async {
    //Make this Synchronous
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("DarkMode", x);
    var teste = prefs.get("DarkMode");
    print(teste);
  }
}
