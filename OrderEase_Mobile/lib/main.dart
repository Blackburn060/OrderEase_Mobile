import 'package:flutter/material.dart';
import 'InicioPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Acesso Rápido',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 37, 82, 186)),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('OrderEase'),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const UserAccountsDrawerHeader(
                accountName: Text('Nome usuário'),
                accountEmail: Text('emailusuário@example.com'),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Inicio'),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => InicioPage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.explore),
                title: const Text('consultar Pedidos'),
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
            ],
          ),
        ),
        body: const MyHomePage(title: 'Nome do Usuario'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment
                .center, // Alinhar os botões no centro horizontal
            children: <Widget>[
              const SizedBox(height: 150), // Espaço superior
              ElevatedButton(
                onPressed: () {
                  // Ação para "Consultar Cardápio"
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(200, 50),
                ),
                child: const Text(
                  'Consultar Cardápio',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),

              const SizedBox(height: 27),
              ElevatedButton(
                onPressed: () {
                  // Ação para "Registrar Consumo"
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(200, 50),
                ),
                child: const Text(
                  'Registrar Consumo',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 27),
              ElevatedButton(
                onPressed: () {
                  // Ação para "Pedidos"
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(200, 50),
                ),
                child: const Text(
                  'Pedidos',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 27),
              ElevatedButton(
                onPressed: () {
                  // Ação para "Encerrar Consumo"
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(200, 50),
                ),
                child: const Text(
                  'Encerrar Consumo',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ));
  }
}
