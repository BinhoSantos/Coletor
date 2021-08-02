import 'dart:io';

import 'package:coletor_nativo/controller/user_controller.dart';
import 'package:coletor_nativo/helpers/database_helpers.dart';
import 'package:coletor_nativo/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
    saveFile();
    if (widget.codbarra == null) {
      _editaCodBarra = codigo_barras(null, "", 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
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
                  height: 120,
                  child: Center(
                    child: Image.asset('assets/images/ICONE-BRASIL.png'),
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
                Navigator.of(context).pop();
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
                Navigator.of(context).pop();
              }),
        ]),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            ButtonWidget(
                text: 'Comece a escanear', onClicked: () => scanBarcode()),
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

  //Void para salvar um arquivo na memória do celular
  Future<bool> saveFile() async {
    Directory directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = (await getExternalStorageDirectory())!;
          print(directory.path);
          String newPath = "";
          List<String> folders = directory.path.split("/");
          for (int x = 1; x < folders.length; x++) {
            String folder = folders[x];
            if (folder != "Android") {
              newPath += ("/" + folder);
            } else
              break;
          }
          newPath = newPath + "/AcesseColetor";
          directory = Directory(newPath);
          print(directory.path);
          //var diretorio = directory.path;
          if (!await directory.exists()) {
            directory.create(recursive: true);
          }
        }
      }
    } catch (e) {}
    return false;
  }

  //Metódo para verificar as permissões
  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }
}
