import 'dart:ffi';

import 'package:coletor_nativo/controller/user_controller.dart';
import 'package:coletor_nativo/helpers/database_helpers.dart';
import 'package:flutter/material.dart';

import 'edita_codbarra_page.dart';

class Historico extends StatefulWidget {
  const Historico({Key? key}) : super(key: key);

  @override
  _HistoricoState createState() => _HistoricoState();
}

class _HistoricoState extends State<Historico> {
  DatabaseHelper db = DatabaseHelper.instance;

  List<codigo_barras> codbarra = <codigo_barras>[];

  var data = [];
  @override
  void initState() {
    super.initState();
    //codigo_barras c = codigo_barras(2, '1235958456126', 2, "Queijo Parmesão");
    //db.insertCodBarra(c);

    db.getCodBarras().then((lista) {
      setState(() {
        codbarra = lista;
      });
    });

    /*   db.getCodBarras().then((lista) {
      print(lista);
    }); */
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Histórico"),
        centerTitle: true,
        actions: <Widget>[],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/scan');
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

  _listaCodBarras(BuildContext context, int index) {
    return GestureDetector(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Produto: " + codbarra[index].nome ?? "",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Código: " + codbarra[index].codigo ?? "",
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
              ],
            ),
          ),
        ),
        onTap: () {
          _exibeCodBarra(codbarra: codbarra[index]);
        });
  }

  void _exibeCodBarra({required codigo_barras codbarra}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CadastroEdita(codbarra: codbarra)));
  }
}
