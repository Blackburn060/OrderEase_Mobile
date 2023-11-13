import 'package:flutter/material.dart';
import 'menulateral.dart';
import 'customizacaoBotoes/CustomButton.dart';

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
      endDrawer: const MenuLateral(),
           // Use endDrawer to display the menu on the left
      body: Center(
        child: Container(
          width: 370,
          height: 540,
          decoration: BoxDecoration(
            color: const Color(0xff203F97).withOpacity(0.0), // Background color
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.black, // Cor da borda
              width: 2.0, // Largura da borda
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomLargeButton(
                text: 'Consultar Cardápio',
                onPressed: () {
                  // Ação para "Consultar Cardápio"
                },
              ),
              const SizedBox(height: 37),
              CustomLargeButton(
                text: 'Registrar Consumo',
                onPressed: () {
                  Navigator.pushNamed(context, '/RegistroPedidos');
                },
              ),
              const SizedBox(height: 37),
              CustomLargeButton(
                text: 'Pedidos',
                onPressed: () {
                  // Ação para "Pedidos"
                },
              ),
              const SizedBox(height: 37),
              CustomLargeButton(
                text: 'Encerrar Consumo',
                onPressed: () {
                  // Ação para "Encerrar Consumo"
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
