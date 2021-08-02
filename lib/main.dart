import 'package:coletor_nativo/controller/dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/app_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Inicio que puxa da memória o Tema que está sendo usado.
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var confirmaTema = prefs.getBool("DarkMode");
  if (confirmaTema == null) {
    DarkMode.instance.isDarkTheme = false;
  } else {
    DarkMode.instance.isDarkTheme = prefs.getBool("DarkMode")!;
  }

  DarkMode.instance.isDarkTheme = prefs.getBool("DarkMode")!;

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}
