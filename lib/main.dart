import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/app_widget.dart';
import 'controller/dark_mode.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var confirmaTema = prefs.getBool("DarkMode");
  if (confirmaTema == null) {
    DarkMode.instance.isDarkTheme = false;
  } else {
    DarkMode.instance.isDarkTheme = prefs.getBool("DarkMode")!;
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}
