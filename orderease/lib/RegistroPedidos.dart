import 'package:flutter/material.dart';
import 'menulateral.dart';

import 'package:flutter/material.dart';

class RegistrarPedidosPage extends StatelessWidget {
  const RegistrarPedidosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Consumo'),
      ),
      drawer: // Seu menu lateral aqui,
      body: Center(
        child: Container(
          width: 300, // Defina o tamanho desejado para o quadrado
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black), // Bordas pretas
            borderRadius: BorderRadius.circular(10), // Borda arredondada
          ),
        
          child: Column(
            children: [
              Text('Mesa'), // Nome "Mesa"
              TextField(
                decoration: InputDecoration(hintText: 'Número da Mesa'),
              ),
              Text('Quantidade'), // Nome "Quantidade"
              TextField(
                decoration: InputDecoration(hintText: 'Quantidade'),
              ),
              Text('Observação'), // Nome "Observação"
              TextField(
                decoration: InputDecoration(hintText: 'Observação'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Ação ao clicar no botão azul
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Cor de fundo azul
                  onPrimary: Colors.white, // Texto em branco
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Borda arredondada
                  ),
                ),
                child: Text('Registrar', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
