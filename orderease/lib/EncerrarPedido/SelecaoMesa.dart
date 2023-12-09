import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orderease/EncerrarPedido/EncerrarComanda.dart';
import 'package:orderease/MenuLateral.dart';

class SelecaoMesa extends StatelessWidget {
  const SelecaoMesa({super.key});

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
      endDrawer: const MenuLateral(),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder(
            future: FirebaseFirestore.instance.collection('pedidos').where('pago', isEqualTo: 'Não').where('status', isEqualTo: 'Finalizado').get(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return Text('Erro: ${snapshot.error}');
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text('Nenhuma mesa encontrada.');
              }

              List<Widget> mesaButtons = [];

              for (var doc in snapshot.data!.docs) {
                var numeroMesa = doc['mesa'];
                mesaButtons.add(
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        _navigateToEncerrarPedidos(context, numeroMesa);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(20), backgroundColor: const Color(0xff203F97),
                        minimumSize: const Size(double.infinity, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: const BorderSide(color: Color.fromARGB(255, 223, 222, 218)),
                        ),
                      ),
                      child: Text(
                        'Mesa $numeroMesa',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...mesaButtons,
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _navigateToEncerrarPedidos(BuildContext context, String mesa) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EncerrarPedidos(mesa: mesa),
    ),
  );
}
}