import 'package:flutter/material.dart';
import 'TelaPrincipal.dart';
import 'SelecaoEscolhas.dart';
import 'Telainicial.dart'; // Importe a classe Telainicial
import 'LoginPage.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const TelaInicial(),
    routes: {
      
      '/LoginPage': (context) => const LoginPage(),
      '/SelecaoEscolhas': (context) => const SelecaoEscolhas(),
      '/TelaInicial': (context) => TelaInicial(),
    },
  ));
}