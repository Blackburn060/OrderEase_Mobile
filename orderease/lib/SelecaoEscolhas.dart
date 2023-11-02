import 'package:flutter/material.dart';
import 'menulateral.dart';

class SelecaoEscolhas extends StatelessWidget {
  const SelecaoEscolhas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
      endDrawer: const MenuLateral(), // Use endDrawer para exibir o menu à esquerda
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 150),
            ElevatedButton(
              onPressed: () {
                // Ação para "Consultar Cardápio"
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Cor de fundo
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(200, 50),
              ),
              child: const Text(
                'Consultar Cardápio',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 27),
            ElevatedButton(
              onPressed: () {
                // Ação para "Registrar Consumo"
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Cor de fundo
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(200, 50),
              ),
              child: const Text(
                'Registrar Consumo',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
            const SizedBox(height: 27),
            ElevatedButton(
              onPressed: () {
                // Ação para "Pedidos"
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Cor de fundo
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(200, 50),
              ),
              child: const Text(
                'Pedidos',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
            const SizedBox(height: 27),
            ElevatedButton(
              onPressed: () {
                // Ação para "Encerrar Consumo"
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Cor de fundo
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(200, 50),
              ),
              child: const Text(
                'Encerrar Consumo',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          Positioned.fill(
            child: Center(
              child: Container(
                width: 200, // Largura do Container
                height: 200, // Altura do Container
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 207, 206, 206).withOpacity(0.3), // Cor preta com transparência
                  borderRadius: BorderRadius.circular(12), // Bordas arredondadas
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}