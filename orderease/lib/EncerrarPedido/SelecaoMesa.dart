import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orderease/EncerrarPedido/EncerrarComanda.dart';
import 'package:orderease/MenuLateral.dart';

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
      endDrawer: const MenuLateral(),
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
                        minimumSize: Size(double.infinity, 0),
                        primary: const Color(0xff203F97), 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Color.fromARGB(255, 223, 222, 218)),
                        ),
                      ),
                      child: Text(
                        'Mesa $numeroMesa',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
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
