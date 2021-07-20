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
  //Faz uma lista com os códigos registrados no banco.
  List<codigo_barras> codbarra = <codigo_barras>[];

  var data = [];
  @override
  void initState() {
    super.initState();
    /*codigo_barras c = codigo_barras(1, '1235958456126', 1, "Queijo Parmesão");
    db.insertCodBarra(c);
       db.getCodBarras().then((lista) {
      print(lista);
    }); */
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
        actions: <Widget>[],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/scan');
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
                        "Produto: " + codbarra[index].nome! ?? "",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Código: " + codbarra[index].codigo! ?? "",
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
      // ignore: unnecessary_null_comparison
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
}
