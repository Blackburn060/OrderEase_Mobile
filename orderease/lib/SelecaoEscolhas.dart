import 'package:flutter/material.dart';
import 'menulateral.dart';
import 'customizacaoBotoes/CustomButton.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SelecaoEscolhas extends StatelessWidget {
  const SelecaoEscolhas({Key? key}) : super(key: key);

  // Function to navigate to WebView screen
  void _navegarParaCardapio(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CardapioWebView(),
      ),
    );
  }

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
      body: Center(
        child: Container(
          width: 370,
          height: 540,
          decoration: BoxDecoration(
            color: const Color(0xff203F97).withOpacity(0.0),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomLargeButton(
                text: 'Consultar Cardápio',
                onPressed: () {
                  _navegarParaCardapio(context); // Call the function
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
                  Navigator.pushNamed(context, '/ConsultarPedidos');
                },
              ),
              const SizedBox(height: 37),
              CustomLargeButton(
                text: 'Encerrar Consumo',
                onPressed: () {
                  Navigator.pushNamed(context, '/SelecaoMesa');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
