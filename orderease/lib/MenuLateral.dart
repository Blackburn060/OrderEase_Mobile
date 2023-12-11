import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MenuLateral extends StatelessWidget {
  const MenuLateral({Key? key}) : super(key: key);

  Future<void> _mostrarDialogoDeConfirmacao(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar saída'),
          content: const Text('Tem certeza de que deseja sair?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Sair'),
              onPressed: () {
                Navigator.of(context).pop();
                _realizarSaida(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _realizarSaida(BuildContext context) {
  
    Navigator.pushNamedAndRemoveUntil(
        context, '/TelaInicial', (route) => false);
  }

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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: const Text('ADMIN'),
            accountEmail: const Text('Admin@gmail.com'),
            currentAccountPicture: GestureDetector(
              onTap: () {
                // Adicione ação aqui se desejar algo ao tocar na imagem do perfil
              },
              child: const CircleAvatar(
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                child: Icon(Icons.person),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Início'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/SelecaoEscolhas');
            },
          ),
          ListTile(
            leading: const Icon(Icons.note_alt_outlined),
            title: const Text('Consultar Pedidos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/ConsultarPedidos');
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Registrar Pedidos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/RegistroPedidos');
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Encerrar comanda'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/SelecaoMesa');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Visualizar Cardápio'),
            onTap: () {
              Navigator.pop(context);
              _navegarParaCardapio(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sair'),
            onTap: () {
              _mostrarDialogoDeConfirmacao(context);
            },
          ),
        ],
      ),
    );
  }
}

class CardapioWebView extends StatelessWidget {
  const CardapioWebView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cardápio'),
      ),
      body: const WebView(
        initialUrl: 'https://orderease.vercel.app/homeCardapio',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
