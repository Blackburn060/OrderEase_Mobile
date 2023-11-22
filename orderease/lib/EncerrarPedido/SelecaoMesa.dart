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
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Adicione a lógica para abrir o menu lateral aqui
            },
          ),
        ],
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
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        _navigateToEncerrarPedidos(context, int.parse(numeroMesa));
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(20),
                        minimumSize: Size(double.infinity, 0), // Largura total da tela
                        primary: const Color(0xff203F97), // Cor de fundo
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0), // Borda arredondada
                        ),
                      ),
                      child: Text(
                        'Mesa $numeroMesa',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white, // Cor do texto
                        ),
                      ),
                    ),
                  ),
                );
              });

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...mesaButtons,
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    alignment: Alignment.bottomLeft,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context); // Voltar para a tela anterior
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0), // Borda arredondada
                        ),
                      ),
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      label: const Text(
                        'Voltar',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black, // Cor do texto
                        ),
                      ),
                    ),
                  ),
                ],
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
