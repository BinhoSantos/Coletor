import 'package:coletor_nativo/widgets/button_widget.dart';
import 'package:coletor_nativo/widgets/main_drawer.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: mainDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            ButtonWidget(
                text: 'Escaneie o código de barras',
                onClicked: () => Navigator.of(context).pushNamed('/scan')),
          ],
        ),
      ),
    );
  }
}
