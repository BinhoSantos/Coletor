import 'package:flutter/material.dart';

// ignore: camel_case_types
class Coletor_Add extends StatefulWidget {
  const Coletor_Add({Key? key}) : super(key: key);

  @override
  _Coletor_AddState createState() => _Coletor_AddState();
}

// ignore: camel_case_types
class _Coletor_AddState extends State<Coletor_Add> {
  @override
  Widget build(BuildContext context) {
    var data = []; //Fazer o import da quantidade de códigos de barra lidos
    return Scaffold(
      appBar: AppBar(
        title: Text("Tipagem Atual"),
      ),
      body: ListView.builder(
        //List View é utilizada para poder usar o "Scroll",
        padding:
            const EdgeInsets.all(8), //Padding é a distância entre os parametros
        itemCount: data.length,
        itemBuilder: (context, int index) {
          return Text(
            data[index],
          );
        },
      ),
      /*body: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Container(
              //Alterar isso aqui para virar uma lista que vai ser construida com a quantidade de códigos inseridos
              height: 50,
              color: Colors.amber[600],
              child: const Center(child: Text('Entry A')),
            ),
            Container(
              height: 50,
              color: Colors.amber[500],
              child: const Center(child: Text('Entry B')),
            ),
            Container(
              height: 50,
              color: Colors.amber[100],
              child: const Center(child: Text('Entry C')),
            ),
          ],
        )*/
    );
  }
}
