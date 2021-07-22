import 'package:coletor_nativo/components/barcode_scanner_page.dart';
import 'package:coletor_nativo/widgets/theme_data.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  static final String title = 'Coletor';
  @override
  Widget build(BuildContext context) {
    return ThemeData2(
      home: MyHomePage(title: title),
      scan: BarcodeScanPage(title: title),
    );
  }
}
