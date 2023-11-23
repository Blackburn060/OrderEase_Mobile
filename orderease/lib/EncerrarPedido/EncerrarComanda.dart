import 'package:flutter/material.dart';
<<<<<<< HEAD
//import 'package:cloud_firestore/cloud_firestore.dart';
=======
import 'package:orderease/MenuLateral.dart';
>>>>>>> e308ab028b140a0590975d8c736058131e165c84

class EncerrarPedidos extends StatelessWidget {
  final int mesa;

  const EncerrarPedidos({Key? key, required this.mesa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        backgroundColor: const Color(0xff203F97),
        title: Text('Encerrar Pedidos - Mesa $mesa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Lógica para abrir o menu lateral
            },
          ),
        ],
=======
        title: Text('Encerrar Pedidos - Mesa ${widget.mesa}'),
        
>>>>>>> e308ab028b140a0590975d8c736058131e165c84
      ),
      endDrawer: const MenuLateral(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Lógica para encerrar a comanda
                _encerrarComanda(context);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(20),
                minimumSize: const Size(double.infinity, 0),
                primary: const Color(0xff0B518A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Encerrar Comanda',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context); // Voltar para a tela anterior
        },
        backgroundColor: const Color(0xff203F97),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.arrow_back),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  void _encerrarComanda(BuildContext context) {
    // Implemente a lógica para encerrar a comanda aqui
    // Pode incluir a atualização do status do pedido, etc.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Comanda encerrada com sucesso!'),
      ),
    );
  }
}
