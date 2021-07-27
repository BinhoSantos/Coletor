import 'package:coletor_nativo/controller/agrupa_quantidade.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    getShared();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: _bodyFull(context), onWillPop: _onBackPressed);
    //_listaCodBarras(context));
  }

  _listaConfiguracoes(BuildContext context) {
    return Container(
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
                      "Agrupamento por código",
                      style: TextStyle(fontSize: 18),
                    ),
                    Container(
                      height: 10,
                    ),
                    Text(
                      "Agrupa a quantidade de itens dos\ncódigos repetidos",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              _customSwitch(context, qtdGroup),
            ],
          ),
        ),
      ),
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

  Future<bool> _onBackPressed() async {
    if (qtdGroup != !qtdGroup) {
      Navigator.of(context).pop();
      print("VOLTA TA FUNCIONANDO");
    }
    return true;
  }
}
