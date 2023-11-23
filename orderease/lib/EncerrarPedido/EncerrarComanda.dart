import 'package:flutter/material.dart';
import 'package:orderease/MenuLateral.dart';

class EncerrarPedidos extends StatefulWidget {
  final int mesa;

  const EncerrarPedidos({Key? key, required this.mesa}) : super(key: key);

  @override
  _EncerrarPedidosState createState() => _EncerrarPedidosState();
}

class _EncerrarPedidosState extends State<EncerrarPedidos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Encerrar Pedidos - Mesa ${widget.mesa}'),
        
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
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff0B518A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(200, 50),
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
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.arrow_back),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
