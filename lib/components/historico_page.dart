import 'dart:io';

import 'package:coletor_nativo/controller/user_controller.dart';
import 'package:coletor_nativo/helpers/database_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'edita_codbarra_page.dart';

class Historico extends StatefulWidget {
  const Historico({Key? key, this.codbarra}) : super(key: key);
  final codigo_barras? codbarra;
  @override
  _HistoricoState createState() => _HistoricoState();
}

class _HistoricoState extends State<Historico> {
  DatabaseHelper db = DatabaseHelper.instance;
  //Faz uma lista com os códigos registrados no banco.
  List<codigo_barras> codbarra = <codigo_barras>[];
  String barcode = '';
  String listaBarra = '';
  late codigo_barras _editaCodBarra;
  @override
  void initState() {
    super.initState();
    if (widget.codbarra == null) {
      _editaCodBarra = codigo_barras(null, "", 1);
    }
    codigo_barras c = codigo_barras(2, '1235958456156', 1);
    db.insertCodBarra(c);
    /*db.getCodBarras().then((lista) {
      print(lista);
    });*/
    _exibeTodosCodBarra();
  }

  //Metódo para exibir os códigos de barra na list view
  void _exibeTodosCodBarra() {
    db.getCodBarras().then((lista) {
      setState(() {
        codbarra = lista;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Histórico"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                decodeCodBarra();
              },
              icon: Icon(Icons.upload)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          scanBarcode();
          //Navigator.of(context).pushNamed('/scan');
          //_exibeCodBarra();
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: codbarra.length,
        itemBuilder: (context, int index) {
          return _listaCodBarras(context, index);
        },
      ),
    );
  }

  //Widget que mostra a lista com os cards e permite que sejam tocados
  _listaCodBarras(BuildContext context, int index) {
    return GestureDetector(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Código: " + codbarra[index].codigo!,
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        "Quantidade : " +
                            (codbarra[index].quantidade).toString(),
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _confirmaExclusao(context, codbarra[index].id!, index);
                  },
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          _exibeCodBarra(codbarra: codbarra[index]);
        });
  }

  Future<void> _exibeCodBarra({codbarra}) async {
    // ignore: non_constant_identifier_names
    final CodBarraAlterado = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CadastroEdita(codbarra: codbarra)));
    if (CodBarraAlterado != null) {
      if (codbarra != null) {
        await db.updateCodBarras(CodBarraAlterado);
      } else {
        await db.insertCodBarra(CodBarraAlterado);
      }
      _exibeTodosCodBarra();
    }
  }

  void _confirmaExclusao(BuildContext context, int idCodBarra, index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Excluir Produto"),
            content: Text("Confirme a exclusão do produto"),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancelar"),
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      codbarra.removeAt(index);
                      db.deleteCodBarras(idCodBarra);
                      Navigator.of(context).pop();
                    });
                  },
                  child: Text("Excluir")),
            ],
          );
        });
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
          Navigator.of(context).pop();
          //Navigator.of(context).pushNamed('/historico');
        }
      });
    } on PlatformException {
      barcode = 'Um erro ocorreu, tente novamente';
    }
  }

  //Inicialmente a quebra da lista para se tornar String
  void decodeCodBarra() {
    var now = DateTime.now().toString();
    print(now);
    listaBarra = codbarra.join(',');
    print(listaBarra);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    var now = DateTime.now().toString();
    final path = await _localPath;
    return File('$path/Coleta$now.txt');
  }

  Future<File> writeListaCodBarra(int counter) async {
    final file = await _localFile;
    return file.writeAsString(listaBarra);
  }
}
