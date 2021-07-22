import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:coletor_nativo/components/home_page.dart';

class mainDrawer extends StatelessWidget {
  const mainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: <Widget>[
        /* DrawerHeader(
          child: Stack(
            children: <Widget>[
              Center(
                child: Text("GOLAÇO"),
              )
            ],
          ),
        ),*/
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(8),
          child: Center(
              child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 18),
                width: double.infinity,
                height: 10,
                child: Center(
                  child: Text(
                    "Coletor",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              )
            ],
          )),
        ),
        ListTile(
            leading: Icon(Icons.history),
            title: Text(
              "Histórico",
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/historico');
            }),
        ListTile(
            leading: Icon(Icons.add),
            title: Text(
              "Adicionar",
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/scan');
            })
      ]),
    );
  }
}
