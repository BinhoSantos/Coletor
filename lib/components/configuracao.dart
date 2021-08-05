import 'package:coletor_nativo/controller/agrupa_quantidade.dart';
import 'package:coletor_nativo/controller/dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Configuracao extends StatefulWidget {
  const Configuracao({Key? key, required this.modelador}) : super(key: key);
  final int modelador;
  @override
  _ConfiguracaoState createState() => _ConfiguracaoState();
}

class _ConfiguracaoState extends State<Configuracao> {
  var agrupaQtd = false;
  var qtdGroup;
  var leitorReal;

  @override
  void initState() {
    super.initState();
    getShared();
    getSharedLeitor();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: _bodyFull(context), onWillPop: _onBackPressed);
    //_listaCodBarras(context));
  }

  _listaConfiguracoes(BuildContext context) {
    return Column(
      children: [
        Card(
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
                        "Agrupamento por código",
                        style: TextStyle(fontSize: 18),
                      ),
                      Container(
                        height: 10,
                      ),
                      Text(
                        "Agrupa a quantidade de itens dos\ncódigos repetidos",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                _customSwitch(context, qtdGroup),
              ],
            ),
          ),
        ),
        Card(
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
                        "Modo Escuro",
                        style: TextStyle(fontSize: 18),
                      ),
                      Container(
                        height: 10,
                      ),
                      Text(
                        "Ativa o modo escuro do aplicativo",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                _customSwitchDark(context),
              ],
            ),
          ),
        ),
        Card(
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
                        "Modo leitor físico",
                        style: TextStyle(fontSize: 18),
                      ),
                      Container(
                        height: 10,
                      ),
                      Text(
                        "Habilita o uso do escaneador físico e \na inserção de dados manualmente ",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                _customSwitchLeitor(context, leitorReal),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _bodyFull(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          _listaConfiguracoes(context),
        ],
      ),
    );
  }

  _customSwitch(BuildContext context, bool x) {
    return Switch(
        value: x, //Atribui value ao booleano da AgrupaQuantidade.dart
        onChanged: (bool s) {
          setState(() {
            SystemChannels.textInput.invokeMethod('TextInput.hide');
            agrupaQtd = s;
            qtdGroup = s;
            print(agrupaQtd);
            print("DIVISORIA");
            print(AgrupaaQT(s).QuantidadeAgrupada);
            SharedPrefs(agrupaQtd);
            getShared();
          });
        });
  }

  _customSwitchDark(BuildContext context) {
    return Switch(
        value: DarkMode
            .instance.isDarkTheme, //Atribui value ao booleano da dark_mode.dart
        onChanged: (value) {
          //Quando o Switch for utilizado
          DarkMode.instance.changeTheme();
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        });
  }

  _customSwitchLeitor(BuildContext context, bool x) {
    return Switch(
        value: x, //Atribui value ao booleano da AgrupaQuantidade.dart
        onChanged: (bool s) {
          setState(() {
            _leitorReal(s);
            getSharedLeitor();
          });
        });
  }

  Future<void> SharedPrefs(bool x) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("QtdAgrupada", x);
    final qtdAgrupada = prefs.getBool("QtdAgrupada");
    print("compressa");
    print(qtdAgrupada);
  }

  Future<void> getShared() async {
    final prefs = await SharedPreferences.getInstance();
    qtdGroup = prefs.getBool("QtdAgrupada");
    setState(() {});
  }

  Future<void> getSharedLeitor() async {
    final prefs = await SharedPreferences.getInstance();
    leitorReal = prefs.getBool("LeitorReal");
    print(leitorReal);
    setState(() {});
  }

  Future<void> _leitorReal(bool leitor) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("LeitorReal", leitor);
  }

  Future<bool> _onBackPressed() async {
    if (qtdGroup != !qtdGroup || leitorReal != !leitorReal) {
      Navigator.of(context).pop();
      print("VOLTA TA FUNCIONANDO");
    }
    return true;
  }
}
