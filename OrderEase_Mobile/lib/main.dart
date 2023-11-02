import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false, // Defina esta propriedade como false
    home: const MyApp(),
    routes: {
      '/HomePage': (context) => const HomePage(),
      '/LoginPage': (context) => const LoginPage(),
    },
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Acesso Rápido',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 37, 82, 186)),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff203F97),
          title: const Text('OrderEase',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )),
          actions: const <Widget>[
            Row(
              children: [
                Text('Nome do Usuário',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundImage:
                      AssetImage('caminho_da_imagem_do_usuario.png'),
                ),
              ],
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: const Text('Nome usuário'),
                accountEmail: const Text('emailusuário@example.com'),
                currentAccountPicture: InkWell(
                  onTap: () {
                    // Navegar para a rota desejada quando a imagem do usuário for pressionada
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
                title: const Text('Inicio'),
                onTap: () {
                  Navigator.pushNamed(context, '/HomePage');
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Remova o título da página
        title: null,
      ),
      body: Center(
          child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Alinhar os botões no centro horizontal
        children: <Widget>[
          const SizedBox(height: 150), // Espaço superior
          Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black, // Cor da sombra
                  offset: Offset(
                      0, 2), // Deslocamento da sombra (horizontal, vertical)
                  blurRadius: 4, // Raio do desfoque da sombra
                  spreadRadius: 0, // Raio da propagação da sombra
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                // Ação para "Registrar Consumo"
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff103085),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: const BorderSide(
                  color: Colors.black, // Cor da borda
                  width: 2.0, // Largura da borda
                ),
                minimumSize: const Size(200, 50),
              ),
              child: const Text(
                'GARÇOM',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 185, height: 53),

          Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black, // Cor da sombra
                  offset: Offset(
                      0, 2), // Deslocamento da sombra (horizontal, vertical)
                  blurRadius: 4, // Raio do desfoque da sombra
                  spreadRadius: 0, // Raio da propagação da sombra
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                // Ação para "Registrar Consumo"
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff103085),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: const BorderSide(
                  color: Colors.black, // Cor da borda
                  width: 2.0, // Largura da borda
                ),
                minimumSize: const Size(200, 50),
              ),
              child: const Text(
                'COZINHA',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff203F97),
          title: const Text('OrderEase',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )),
          actions: const <Widget>[
            Row(
              children: [
                Text('Nome do Usuário',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundImage:
                      AssetImage('caminho_da_imagem_do_usuario.png'),
                ),
              ],
            ),
          ],
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

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null, // Remova o título da página
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Centralize verticalmente
          crossAxisAlignment:
              CrossAxisAlignment.center, // Centralize horizontalmente
          children: <Widget>[
            const Text(
              'Login',
              style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            // Campo de usuário
            Padding(
              padding:
                  const EdgeInsets.all(8.0), // Adicione o espaçamento desejado
              child: Container(
                width: 250, // Defina a largura desejada
                child: const TextField(
                  decoration: InputDecoration(
                    labelText: 'Usuário',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black), // Cor da linha inferior
                    ),
                  ),
                ),
              ),
            ),
            // Campo de senha
            Padding(
              padding:
                  const EdgeInsets.all(8.0), // Adicione o espaçamento desejado
              child: Container(
                width: 250, // Defina a largura desejada
                child: const TextField(
                  obscureText: true, // Para ocultar a senha
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black), // Cor da linha inferior
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16), // Espaçamento entre os campos e o botão
            // Botão de entrar
            ElevatedButton(
              onPressed: () {
                // Ação para "Registrar Consumo"
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff103085),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: const BorderSide(
                  color: Colors.black, // Cor da borda
                  width: 2.0, // Largura da borda
                ),
                minimumSize: const Size(200, 50),
              ),
              child: const Text(
                'ENTRAR',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}