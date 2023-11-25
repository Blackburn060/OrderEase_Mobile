import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../menulateral.dart';

class Pedido {
  final int numeroPedido;
  final String mesa;
  final String status;
  final List<Map<String, dynamic>> itens;

  Pedido({
    required this.numeroPedido,
    required this.mesa,
    required this.status,
    required this.itens,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      numeroPedido: json['numeroPedido'],
      mesa: json['mesa'],
      status: json['status'],
      itens: List<Map<String, dynamic>>.from(json['itens']),
    );
  }
}

class TelaCozinha extends StatefulWidget {
  const TelaCozinha({Key? key}) : super(key: key);

  @override
  TelaCozinhaState createState() => TelaCozinhaState();
}

class TelaCozinhaState extends State<TelaCozinha> {
  late List<Pedido> pedidos;

  @override
  void initState() {
    super.initState();
    pedidos = [];
    fetchPedidos();
  }

  Future<void> fetchPedidos() async {
    final response = await http.get(
        Uri.parse('https://orderease-api.onrender.com/api/obter-pedidos'));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      setState(() {
        pedidos =
            jsonResponse.map((data) => Pedido.fromJson(data)).toList();
      });
    } else {
      throw Exception('Failed to load pedidos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos - Cozinha'),
      ),
      endDrawer: MenuLateral(),
      body: pedidos.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: pedidos.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(16.0),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Nº ${pedidos[index].numeroPedido.toString()} - ',
                            ),
                            Text(
                              'Mesa ${pedidos[index].mesa}',
                            ),
                            Spacer(),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Text(
                                pedidos[index].status,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Itens:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: pedidos[index].itens.map((item) {
                            return Text(
                              '  - ${item['nome']} (${item['quantidade']}x) - ${item['observacao']}',
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Adicione aqui o que você quer fazer ao clicar em um pedido
                    },
                  ),
                );
              },
            ),
    );
  }
}
