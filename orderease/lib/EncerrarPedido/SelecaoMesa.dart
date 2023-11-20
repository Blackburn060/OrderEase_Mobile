import 'package:flutter/material.dart';
import 'EncerrarComanda.dart'; // Importe a classe EncerrarPedidos

class SelecaoMesa extends StatelessWidget {
  const SelecaoMesa({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff203F97),
        title: const Text(
          'Seleção de Mesa',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _navigateToEncerrarPedidos(context, 1); // Mesa 1
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(20),
                ),
                child: Text(
                  'Mesa 1',
                  style: TextStyle(fontSize: 30),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _navigateToEncerrarPedidos(context, 2); // Mesa 2
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(20),
                ),
                child: Text(
                  'Mesa 2',
                  style: TextStyle(fontSize: 30),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Voltar para a tela anterior
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(20),
                ),
                child: const Text(
                  'Voltar',
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToEncerrarPedidos(BuildContext context, int mesa) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EncerrarPedidos(mesa: mesa),
      ),
    );
  }
}
