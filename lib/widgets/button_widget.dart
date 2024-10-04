import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    required this.text,
    required this.onClicked,
    //Void Callback é o responsável por dar a função do
    //botão/widget que estiver sendo usada
    Key? key,
  }) : super(key: key);

  @override
  // ignore: deprecated_member_use
  Widget build(BuildContext context) => ElevatedButton(
        child: Text(
          text,
          style: TextStyle(fontSize: 24),
        ),  
        style: ElevatedButton.styleFrom(
          shape: StadiumBorder(), 
          backgroundColor: Theme.of(context).primaryColor,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          foregroundColor: Colors.white,
        ),
        onPressed: onClicked,
      );
}
