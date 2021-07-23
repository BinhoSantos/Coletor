import 'dart:io';

import 'package:coletor_nativo/controller/user_controller.dart';
import 'package:coletor_nativo/helpers/database_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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
  String diretorio = '';
  late codigo_barras _editaCodBarra;
  @override
  void initState() {
    super.initState();
    if (widget.codbarra == null) {
      _editaCodBarra = codigo_barras(null, "", 1);
    }
    //codigo_barras c = codigo_barras(2, '1235958456156', 1);
    //db.insertCodBarra(c);
    /*db.getCodBarras().then((lista) {
      print(lista);
    });*/
    _exibeTodosCodBarra();
  }

  //Metódo para exibir os códigos de barra na list view
  void _exibeTodosCodBarra() {
    db.getCodBarrasCount().then((lista) {
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
                //decodeCodBarra();
                _confirmaFechamento(context);
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
                    _confirmaExclusao(
                        context, int.parse(codbarra[index].codigo!), index);
                    //_confirmaExclusao(context, codbarra[index].int!, index);
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
        //await db.updateCodBarras(CodBarraAlterado);
        await db.updateCodBarrasPerCodigo(CodBarraAlterado);
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
                      db.deleteCodBarrasStr(idCodBarra);
                      //db.deleteCodBarras(Codigo);
                      Navigator.of(context).pop();
                    });
                  },
                  child: Text("Excluir")),
            ],
          );
        });
  }

  void _confirmaFechamento(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Deseja realizar a exportação?"),
            content:
                Text("Ao exportar a coleta todos os dados serão deletados."),
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
                      saveFile();
                      Navigator.of(context).pop();
                      //_exibeTodosCodBarra();
                      _showCaminhoExp();
                    });
                  },
                  child: Text("Exportar")),
            ],
          );
        });
  }

  void _showCaminhoExp() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Local de Exportação"),
            content: Text(
                "Seus dados foram exportados para a pasta AcesseColetor nos documentos"),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Ok"),
              ),
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
          _exibeTodosCodBarra();
          //Navigator.of(context).pop();
          //Navigator.of(context).pushNamed('/historico');
        }
      });
    } on PlatformException {
      barcode = 'Um erro ocorreu, tente novamente';
    }
  }

  //Inicialmente a quebra da lista para se tornar String
  void decodeCodBarra() {
    var now = DateTime.now().day.toString();
    now = '_' + now + '_' + DateTime.now().month.toString();
    now = now + '_' + DateTime.now().year.toString();
    print(now);
    listaBarra = ('{');
    listaBarra = listaBarra + codbarra.join('\n');
    listaBarra = listaBarra + ('}');
    print(listaBarra);
    writeListaCodBarra();
  }

//Void para salvar um arquivo na memória do celular
  Future<File> get _localFile async {
    var now = DateTime.now().day.toString();
    now = '_' + now + '_' + DateTime.now().month.toString();
    now = now + '_' + DateTime.now().year.toString();
    final path = await diretorio;
    return File('$path/Coleta$now.txt');
  }

//Void para salvar um arquivo na memória do celular
  Future<File> writeListaCodBarra() async {
    final file = await _localFile;
    db.deleteCodBarrasAll();
    _exibeTodosCodBarra();
    return file.writeAsString(listaBarra, mode: FileMode.write);
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
          diretorio = directory.path;
          if (!await directory.exists()) {
            directory.create(recursive: true);
            listaBarra = listaBarra + codbarra.join(',\n');
            print(listaBarra);
            writeListaCodBarra();
          }
          if (await directory.exists()) {
            listaBarra = listaBarra + codbarra.join(',\n');
            print(listaBarra);
            writeListaCodBarra();
          }
        }
      }
    } catch (e) {}
    return false;
  }

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
