import 'dart:convert';

import 'package:coletor_nativo/controller/user_controller.dart';
import 'package:coletor_nativo/helpers/database_helpers.dart';
import 'package:flutter/material.dart';

import 'edita_codbarra_page.dart';

class CadastroCodigoBarra extends StatefulWidget {
  const CadastroCodigoBarra({Key? key}) : super(key: key);

  @override
  _CadastroCodigoBarraState createState() => _CadastroCodigoBarraState();
}

class _CadastroCodigoBarraState extends State<CadastroCodigoBarra> {
  get codbarra => codigo_barras(id, codigo, quantidade);

  final _nomeFocus = FocusNode();
  late int id, index, quantidade;
  late String nome, codigo;
  DatabaseHelper db = DatabaseHelper.instance;

  final _editaNomeProduto = TextEditingController();
  final _editaCodigoProduto = TextEditingController();
  final _editaQuantidadeProduto = TextEditingController();

  // ignore: unused_field
  late codigo_barras _editaCodBarra;

  //List<codigo_barras> codbarra = <codigo_barras>[];

  @override
  void initState() {
    super.initState();

    _pegaUltimoId();
  }

  void _pegaUltimoId() {
    db.selectDados().then((lista) {
      setState(() {});
      //id = _editaCodBarra.id + 1;
      print(id);

      /* _editaCodBarra = codigo_barras.fromMap(lista);
      print(_editaCodBarra);
      id = lista[1].id;
      print(" Parte 1" + id.toString());*/
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de Produto"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (nome == "" || nome.length <= 1) {
            _exibeAviso();
          } else {
            nome = codbarra.nome;
            quantidade = codbarra.quantidade;
            codigo = codbarra.codigo;
            db.insertCodBarra(codbarra);
            Navigator.of(context).pushNamed('/h');
          }
        },
        child: Icon(Icons.save),
        /*onPressed: () {
          if (_editaNomeProduto != null && _editaNomeProduto.text) {
           // Navigator.pop(context, _editaNomeProduto);
            /*Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CadastroEdita(codbarra: _editaCodBarra)));*/
          } else {
            _exibeAviso();
            FocusScope.of(context)
                .requestFocus(_nomeFocus); //Leva o foco para o campo de nome
          }
        },
        child: Icon(Icons.save),
      */
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
                //controller: _editaCodigoProduto,
                decoration: InputDecoration(labelText: "Código"),
                enabled: true,
                onChanged: (text) {
                  codigo = text;
                }),
            TextField(
                decoration:
                    InputDecoration(labelText: "Quantidade", hintText: "1"),
                enabled: true,
                onChanged: (text) {
                  quantidade = 1;
                }),
          ],
        ),
      ),
    );
  }

  //Exibe aviso de nome inválido, quando um nome inválido é digitado
  void _exibeAviso() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Quantidade"),
            content: new Text("A quantidade não pode ser 0"),
            actions: <Widget>[
              new TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); //Fecha o alertbox
                  },
                  child: Text("Fechar"))
            ],
          );
        });
  }
}
