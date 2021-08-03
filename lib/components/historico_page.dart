import 'dart:io';

import 'package:coletor_nativo/components/configuracao.dart';
import 'package:coletor_nativo/controller/user_controller.dart';
import 'package:coletor_nativo/helpers/database_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'edita_codbarra_page.dart';
import 'package:device_info_plus/device_info_plus.dart';

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
  List<codigo_barras> codbarraimpressao = <codigo_barras>[];
  static final _deviceInfoPlugin = DeviceInfoPlugin();
  String barcode = '';
  String listaBarra = '';
  String diretorio = '';
  int androidVersion = 0;
  bool? qtdAgrupada;
  int trava = 1;
  late codigo_barras _editaCodBarra;

  @override
  void initState() {
    super.initState();
    getSDKVersion();

    SharedPrefs();

    if (widget.codbarra == null) {
      _editaCodBarra = codigo_barras(null, "", 1);
    }
    codigo_barras c = codigo_barras(null, '01057072', 1);
    db.insertCodBarra(c);
    //codigo_barras c1 = codigo_barras(2, '1235958456185', 1);
    //db.insertCodBarra(c1);
    /*db.getCodBarras().then((lista) {
      print(lista);
    });*/
    //_exibeTodosCodBarra();
  }

  //Metódo para exibir os códigos de barra na list view
  void _exibeTodosCodBarra() {
    print(qtdAgrupada);
    db.getCodBarrasCount().then((value) => codbarraimpressao = value);

    if (qtdAgrupada == true) {
      db.getCodBarrasCount().then((lista) {
        setState(() {
          codbarra = lista;
        });
      });
    } else {
      db.getCodBarras().then((lista) {
        setState(() {
          codbarra = lista;
        });
      });
    }
  }

  //Widget principal do projeto
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Histórico"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                if (codbarraimpressao.isEmpty) {
                  _showSemDados(context);
                } else {
                  _confirmaFechamento(context);
                }
              },
              icon: Icon(Icons.upload_file_rounded)),
          IconButton(
              onPressed: () {
                _alteracaoConfiguracao();
              },
              icon: Icon(Icons.settings)),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    if (qtdAgrupada == true) {
                      _confirmaExclusao(
                          context,
                          int.parse(codbarra[index].codigo!),
                          (codbarra[index].codigo!),
                          index);
                    } else {
                      _confirmaExclusao(context, codbarra[index].id!,
                          (codbarra[index].codigo!), index);
                    }
                    //Inserir o if do qtdAgrupada aqui e fazer a separação
                    //
                  },
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          if (qtdAgrupada == false) {
            _exibeCodBarra(codbarra: codbarra[index]);
          }
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
        //Altera a quantidade com o Select normal
        await db.updateCodBarras(CodBarraAlterado);
        //Tenta alterar a quantidade com o Select ORDER BY
        //await db.updateCodBarrasPerCodigo(CodBarraAlterado);
        print(codbarra);
      } else {
        await db.insertCodBarra(CodBarraAlterado);
      }
      _exibeTodosCodBarra();
    }
  }

  //Dá um setState forçado para poder rodar
  Future<void> _alteracaoConfiguracao() async {
    final configuracaoAlterada = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Configuracao(
                  modelador: trava,
                )));
    if (configuracaoAlterada != null) {
      SharedPrefs();
    } else {
      SharedPrefs();
    }
  }

  //Void que exclui o código de barras do banco
  void _confirmaExclusao(
      BuildContext context, int idCodBarra, String codCodigoBarra, index) {
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
                      if (qtdAgrupada == true) {
                        db.deleteCodBarrasStr(codCodigoBarra);
                      } else {
                        db.deleteCodBarras(idCodBarra);
                      }
                      Navigator.of(context).pop();
                    });
                  },
                  child: Text("Excluir")),
            ],
          );
        });
  }

  void _showSemDados(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Sem dados para a exportação."),
            content: Text("Não existe nenhuma coleta para ser exportada."),
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

  //Void que mostra o alertbox que leva o arquivo .txt
  void _confirmaFechamento(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Deseja realizar a exportação?"),
            content: Text("Confirme se deseja prosseguir com a exportação."),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancelar"),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showManterDados(context);
                    //_exibeTodosCodBarra();
                  },
                  child: Text("Exportar")),
            ],
          );
        });
  }

  //Void que mostra o alertbox que leva o arquivo .txt
  void _showManterDados(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Deseja apagar os dados?"),
            content: Text(
                "Ao aceitar todos os dados coletados serão deletados e uma nova coleta será iniciada."),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    saveFile(false);
                    Navigator.of(context).pop();
                    //_exibeTodosCodBarra();
                    if (androidVersion >= 30) {
                      _showCaminhoExp(
                          "Seus dados foram exportados para a pasta matriz do Coletor");
                    } else {
                      _showCaminhoExp(
                          "Seus dados foram exportados para a pasta AcesseColetor nos documentos");
                    }
                  });
                },
                child: Text("Manter"),
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      saveFile(true);
                      Navigator.of(context).pop();
                      //_exibeTodosCodBarra();
                      if (androidVersion >= 30) {
                        _showCaminhoExp(
                            "Seus dados foram exportados para a pasta matriz do Coletor");
                      } else {
                        _showCaminhoExp(
                            "Seus dados foram exportados para a pasta AcesseColetor nos documentos");
                      }
                    });
                  },
                  child: Text("Apagar")),
            ],
          );
        });
  }

  void _showCaminhoExp(String x) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Local de Exportação"),
            content: Text(x),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Share.shareFiles([diretorio]);
                },
                child: Text("Ok"),
              ),
            ],
          );
        });
  }

  //Leitor de código de barras
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
        }
      });
    } on PlatformException {
      barcode = 'Um erro ocorreu, tente novamente';
    }
  }

//Void para salvar um arquivo na memória do celular
  Future<File> get _localFile async {
    var now = 'Coleta_';
    now = now + DateTime.now().day.toString();
    now = '_' + now + '_' + DateTime.now().month.toString();
    now = now + '_' + DateTime.now().year.toString();
    now = now + '_' + DateTime.now().hour.toString();
    now = now + '_' + DateTime.now().minute.toString();
    var uuid = Uuid().v1();
    final path = await diretorio;
    diretorio = '$path/$uuid$now.txt';
    return File('$path/$uuid$now.txt');
  }

  //Void para escrever no arquivo que será memória do celular
  Future<File> writeListaCodBarra(bool deletar) async {
    final file = await _localFile;
    if (deletar == true) {
      db.deleteCodBarrasAll();
    }
    _exibeTodosCodBarra();
    return file.writeAsString(listaBarra, mode: FileMode.write);
  }

  //Void para salvar um arquivo na memória do celular
  Future<bool> saveFile(bool deletar) async {
    Directory directory;
    try {
      if (Platform.isAndroid) {
        if (androidVersion < 30) {
          //Condição para versões do Android antes do 11
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
              listaBarra = codbarraimpressao.join('\n');
              listaBarra = listaBarra + '\n';
              print(listaBarra);
              writeListaCodBarra(deletar);
            }
            if (await directory.exists()) {
              listaBarra = codbarraimpressao.join('\n');
              listaBarra = listaBarra + '\n';
              print(listaBarra);
              writeListaCodBarra(deletar);
            }
          }
        } else {
          //Caso a SDK do Android seja maior que 29 e consequentemente acima do
          //Android 10
          directory = (await getExternalStorageDirectory())!;
          diretorio = directory.path;
          if (!await directory.exists()) {
            directory.create(recursive: true);
            listaBarra = codbarraimpressao.join('\n');
            listaBarra = listaBarra + '\n';
            print(listaBarra);
            writeListaCodBarra(deletar);
          }
          if (await directory.exists()) {
            listaBarra = codbarraimpressao.join('\n');
            listaBarra = listaBarra + '\n';
            print(listaBarra);
            writeListaCodBarra(deletar);
          }
        }
      } else {
        //Na teoria esse código salva dentro da pasta do iPhone
        if (await _requestPermission(Permission.storage)) {
          directory = await getApplicationDocumentsDirectory();
        } else {
          return false;
        }
        if (!await directory.exists()) {
          await directory.create(recursive: true);
          diretorio = directory.path;
          print(diretorio);
        }
        if (await directory.exists()) {
          listaBarra = listaBarra + codbarraimpressao.join(',\n');
          writeListaCodBarra(deletar);
        }
      }
    } catch (e) {}
    return false;
  }

  //Metódo para verificar as permissões do Android ou IOS
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

  //Seta false para o agrupamento por código na primeira vez que o app for aberto
  Future<void> SharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final qtdGroup = prefs.getBool("QtdAgrupada");
    if (qtdGroup == null) {
      prefs.setBool("QtdAgrupada", false);
      qtdAgrupada = prefs.getBool("QtdAgrupada");
    } else {
      qtdAgrupada = prefs.getBool("QtdAgrupada");
    }
    print(qtdAgrupada);
    print("Deveria passar aqui");
    _exibeTodosCodBarra();
  }

  // Pega a versão da Sdk do android
  Future<String> getSDKVersion() async {
    final info = await _deviceInfoPlugin.androidInfo;
    androidVersion = info.version.sdkInt!.toInt();
    print(androidVersion);
    return info.version.sdkInt.toString();
  }
}
