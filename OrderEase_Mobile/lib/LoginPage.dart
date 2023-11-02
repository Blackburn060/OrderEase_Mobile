import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                Navigator.pushNamed(context, '/SelecaoEscolhas');
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
