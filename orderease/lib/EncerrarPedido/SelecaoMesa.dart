import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orderease/EncerrarPedido/EncerrarComanda.dart';

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
          child: FutureBuilder(
            future: FirebaseFirestore.instance.collection('pedidos').get(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return Text('Erro: ${snapshot.error}');
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Text('Nenhuma mesa encontrada.');
              }

              List<Widget> mesaButtons = [];

              snapshot.data!.docs.forEach((doc) {
                var numeroMesa = doc['mesa'];
                mesaButtons.add(
                  ElevatedButton(
                    onPressed: () {
                      _navigateToEncerrarPedidos(context, int.parse(numeroMesa));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(20),
                    ),
                    child: Text(
                      'Mesa $numeroMesa',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                );
                mesaButtons.add(const SizedBox(height: 16));
              });

              mesaButtons.add(
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
              );

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: mesaButtons,
              );
            },
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
