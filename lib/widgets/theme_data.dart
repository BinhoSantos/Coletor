import 'package:coletor_nativo/components/barcode_scanner_page.dart';
import 'package:coletor_nativo/components/cadastro_codbarra.dart';
import 'package:coletor_nativo/components/coletor_add_page.dart';
import 'package:coletor_nativo/components/historico_page.dart';
import 'package:coletor_nativo/components/home_page.dart';
import 'package:coletor_nativo/components/login_screen.dart';
import 'package:flutter/material.dart';

//Classe responsável pelas rotas e pelo design do aplicativo
class ThemeData2 extends StatelessWidget {
  const ThemeData2(
      {Key? key, required MyHomePage home, required BarcodeScanPage scan})
      : super(key: key);
  static final String title = 'Coletor - Testes';
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'É tempo de testes',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        routes: <String, WidgetBuilder>{
          '/t': (context) => LoginPage(),
          '/': (context) => MyHomePage(title: title),
          '/scan': (context) => BarcodeScanPage(
                title: title,
              ),
          '/addcodbarra': (context) => Coletor_Add(),
          '/historico': (context) => Historico(),
          "/cad": (context) => CadastroCodigoBarra(),
        },
      );
}
