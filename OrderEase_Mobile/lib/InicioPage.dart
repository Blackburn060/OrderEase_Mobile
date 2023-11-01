import 'package:flutter/material.dart';

class InicioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página de Início'),
      ),
      body: Center(
        child: Text('Conteúdo da Página de Início'),
      ),
    );
  }
}