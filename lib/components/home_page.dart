import 'package:coletor_nativo/controller/user_controller.dart';
import 'package:coletor_nativo/helpers/database_helpers.dart';
import 'package:coletor_nativo/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title, this.codbarra}) : super(key: key);
  final codigo_barras? codbarra;
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseHelper db = DatabaseHelper.instance;
  String barcode = '';
  late codigo_barras _editaCodBarra;
  @override
  void initState() {
    super.initState();
    if (widget.codbarra == null) {
      _editaCodBarra = codigo_barras(null, "", 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: Column(children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(8),
            child: Center(
                child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 18),
                  width: double.infinity,
                  height: 10,
                  child: Center(
                    child: Text(
                      "Coletor",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                )
              ],
            )),
          ),
          ListTile(
              leading: Icon(Icons.history),
              title: Text(
                "Histórico",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.of(context).pushNamed('/historico');
              }),
          ListTile(
              leading: Icon(Icons.add),
              title: Text(
                "Adicionar",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                scanBarcode();
              }),
        ]),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            ButtonWidget(
                text: 'Escaneie o código de barras',
                onClicked: () => scanBarcode()),
            //onClicked: () => Navigator.of(context).pushNamed('/scan')),
          ],
        ),
      ),
    );
  }

  Future<void> scanBarcode() async {
    try {
      final barcode = await FlutterBarcodeScanner.scanBarcode(
        '#010101',
        'Cancelar',
        true,
        ScanMode.BARCODE,
      );

      if (!mounted) return;

      setState(() {
        this.barcode = barcode;
        if (barcode != "" && barcode != "-1") {
          _editaCodBarra = codigo_barras(null, barcode, 1);
          db.insertCodBarra(_editaCodBarra);
          Navigator.of(context).pushNamed('/historico');
        }
      });
    } on PlatformException {
      barcode = 'Um erro ocorreu, tente novamente';
    }
  }
}
