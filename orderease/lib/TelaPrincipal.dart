import 'package:flutter/material.dart';
import 'menulateral.dart';

class TelaPrincipal extends StatelessWidget {
  const TelaPrincipal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff203F97),
        title: const Text(
          'OrderEase',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: const MenuLateral(), // Aqui você inclui o menu lateral
      body: const Center(
        // Conteúdo da tela principal
      ),
    );
  }
}
