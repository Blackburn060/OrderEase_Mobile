import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Cozinha/TelaCozinha.dart';
import 'SelecaoEscolhas.dart';
import 'Telainicial.dart';
import 'LoginPage.dart';
import 'firebase_options.dart';
import 'TelaPedidos/FuncionalidadesPedidos.dart';
import 'EncerrarPedido/SelecaoMesa.dart';
import 'TelaPedidos/ConsultaPedidos.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/TelaInicial',
      routes: {
        '/LoginPage': (context) => const LoginPage(),
        '/SelecaoEscolhas': (context) => const SelecaoEscolhas(),
        '/TelaInicial': (context) => const TelaInicial(),
        '/MenuLateral': (context) => const SelecaoEscolhas(),
        '/RegistroPedidos': (context) => const FuncionalidadesPedidos(),
        '/SelecaoMesa': (context) => const SelecaoMesa(),
        '/ConsultarPedidos': (context) => const ConsultaPedidos(),
        '/TelaCozinha': (context) => const TelaCozinha(), // Adicione esta linha
      },
    );
  }
}
