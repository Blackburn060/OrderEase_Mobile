import 'package:flutter/material.dart';

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
    // Adicione aqui qualquer lógica necessária ao sair
    // Por exemplo, você pode fazer logout, limpar o estado da aplicação, etc.
    Navigator.pushNamedAndRemoveUntil(
        context, '/TelaInicial', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: const Text('Nome usuário'),
            accountEmail: const Text('emailusuario@example.com'),
            currentAccountPicture: GestureDetector(
              onTap: () {
                // Navegar para a tela de LoginPage quando o ícone do usuário for pressionado
                Navigator.pushNamed(context, '/LoginPage');
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Início'),
            onTap: () {
              Navigator.pop(context); // Fecha o menu lateral
              Navigator.pushNamed(
                  context, '/HomePage'); // Navega para a página de início
            },
          ),
          ListTile(
            leading: const Icon(Icons.explore),
            title: const Text('Consultar Pedidos'),
            onTap: () {
              // Adicione ação aqui para navegar para a página de notificações
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Registrar Pedidos'),
            onTap: () {
              // Adicione ação aqui para navegar para a página de notificações
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Mesas'),
            onTap: () {
              // Adicione ação aqui para navegar para a página de notificações
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Encerrar comanda'),
            onTap: () {
              // Adicione ação aqui para navegar para a página de notificações
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            onTap: () {
              // Adicione ação aqui para navegar para a página de configurações
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
