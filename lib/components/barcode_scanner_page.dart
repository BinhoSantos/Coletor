import 'package:coletor_nativo/controller/user_controller.dart';
import 'package:coletor_nativo/helpers/database_helpers.dart';
import 'package:coletor_nativo/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BarcodeScanPage extends StatefulWidget {
  const BarcodeScanPage({
    Key? key,
    required this.title,
    this.codbarra,
  }) : super(key: key);
  final codigo_barras? codbarra;
  final String title;
  @override
  _BarcodeScanPageState createState() => _BarcodeScanPageState();
}

class _BarcodeScanPageState extends State<BarcodeScanPage> {
  DatabaseHelper db = DatabaseHelper.instance;
  String barcode = '';
  late codigo_barras _editaCodBarra;
  @override
  void initState() {
    super.initState();
    if (widget.codbarra == null) {
      _editaCodBarra = codigo_barras(null, "", 1, "");
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Resultado do Scan',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '$barcode',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 72),
              ButtonWidget(
                text: 'Escanear',
                onClicked: scanBarcode,
              ),
            ],
          ),
        ),
      );

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
          _editaCodBarra = codigo_barras(null, barcode, 1, "");
          db.insertCodBarra(_editaCodBarra);
          Navigator.of(context).pushNamed('/historico');
        }
      });
    } on PlatformException {
      barcode = 'Isso não era pra acontecer, tenta de novo';
    }
  }
}
