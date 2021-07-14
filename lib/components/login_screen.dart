import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';
  String senha = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            //Implementa um Scroll Simples para poder mexer enquanto o teclado está na tela
            child: SizedBox(
      width: MediaQuery.of(context).size.width,
      //MediaQuery serve para buscar o valor atual da tela, tanto para altura quanto para largura
      height: MediaQuery.of(context).size.height,
      child: Padding(
          padding: const EdgeInsets.all(
              8.0), // Distância do que vem aqui dentro para as bordas
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, //Alinhamento Principal
            children: [
              Container(
                width: 200,
                height: 200,
                //child: Image.asset('assets/images/logoBrasil.png'),
              ),
              Container(
                height: 30,
              ),
              TextField(
                onChanged: (text) {
                  email = text;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  //Metódo para deixar o TextField mais bonito
                  border: OutlineInputBorder(), //Ajeita a borda do TextField
                  labelText: 'Email',
                ),
              ),
              Container(
                height: 15,
              ),
              TextField(
                onChanged: (text) {
                  senha = text;
                },
                obscureText: true,
                decoration: InputDecoration(
                  //Metódo para deixar o TextField mais bonito
                  border: OutlineInputBorder(), //Ajeita a borda do TextField
                  labelText: 'Senha',
                ),
              ),
              Container(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  if (email == "teste@gmail.com" && senha == "123") {
                    //Conexão com o banco para buscar usuário
                    print("Tá certinho meu chegado, vamo que vamo.");
                    Navigator.of(context).pushReplacementNamed('/home');
                  } else {
                    print("login incorreto!");
                  }
                },
                child: Text('Entrar'),
              )
            ],
          )),
    )));
  }
}
