import 'package:coletor_nativo/components/barcode_scanner_page.dart';
import 'package:coletor_nativo/components/home_page.dart';
import 'package:coletor_nativo/components/login_screen.dart';
import 'package:flutter/material.dart';

class ThemeData2 extends StatelessWidget {
  const ThemeData2(
      {Key? key, required MyHomePage home, required BarcodeScanPage scan})
      : super(key: key);
  static final String title = 'Barcode Scanner';
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'É tempo de testes',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        routes: <String, WidgetBuilder>{
          '/': (context) => LoginPage(),
          '/home': (context) => MyHomePage(title: title),
          '/scan': (context) => BarcodeScanPage(
                title: title,
              ),
        },
      );
}
