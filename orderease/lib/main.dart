import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'TelaPrincipal.dart';
import 'SelecaoEscolhas.dart';
import 'Telainicial.dart';
import 'LoginPage.dart';
import 'firebase_options.dart';
import 'RegistroPedidos.dart';
/* import 'firebase_options.dart'; */

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
        '/RegistroPedidos': (context) => const RegistroPedidos(),
        
      }, 
    );
  }
}
