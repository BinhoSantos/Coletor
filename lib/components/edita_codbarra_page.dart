import 'package:coletor_nativo/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//Cria as variavéis para o teste da edição
class CadastroEdita extends StatefulWidget {
  final codigo_barras? codbarra;
  CadastroEdita({this.codbarra});

  @override
  _CadastroEditaState createState() => _CadastroEditaState();
}

class _CadastroEditaState extends State<CadastroEdita> {
  final _editaCodigoProduto = TextEditingController();
  final _editaQuantidadeProduto = TextEditingController();
  final _nomeFocus = FocusNode();

  late String title;
  late int Conversor;
  bool editando = false;

  late codigo_barras _editaCodBarra;

  //Persistência para ver se o código é nulo ou já existente para habilitar a edição.
  @override
  void initState() {
    super.initState();
    if (widget.codbarra == null) {
      _editaCodBarra = codigo_barras(null, "", 0);
    } else {
      _editaCodBarra = codigo_barras.fromMap(widget.codbarra!.toMap());
      _editaCodigoProduto.text = _editaCodBarra.codigo!;
      _editaQuantidadeProduto.text = _editaCodBarra.quantidade.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_editaCodBarra.quantidade == 0
              ? "Cadastro de Produto"
              : "Editar Produto"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editaQuantidadeProduto.text != "" &&
                _editaQuantidadeProduto.text != "0") {
              Conversor = int.parse(_editaQuantidadeProduto.text);
              _editaCodBarra.quantidade = Conversor;
              Navigator.pop(context, _editaCodBarra);
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
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _editaCodigoProduto,
                decoration: InputDecoration(labelText: "Código"),
                enabled: false,
              ),
              TextFormField(
                focusNode: _nomeFocus,
                maxLength: 10,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                keyboardType: TextInputType.number,
                controller: _editaQuantidadeProduto,
                decoration:
                    InputDecoration(labelText: "Quantidade", counterText: ""),
                enabled: true,
              ),
            ],
          ),
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
            title: Text("Quantidade inválida"),
            content: new Text("Informe uma quantidade válida para o produto"),
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
