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

class ConsultaPedidos extends StatefulWidget {
  const ConsultaPedidos({Key? key}) : super(key: key);

  @override
  ConsultaPedidosState createState() => ConsultaPedidosState();
}

class ConsultaPedidosState extends State<ConsultaPedidos> {
  late List<Pedido> pedidos;

  @override
  void initState() {
    super.initState();
    pedidos = [];
    fetchPedidos();
  }

  Future<void> fetchPedidos() async {
    final response = await http
        .get(Uri.parse('https://orderease-api.onrender.com/api/obter-pedidos'));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      setState(() {
        pedidos = jsonResponse.map((data) => Pedido.fromJson(data)).toList();
      });
    } else {
      throw Exception('Failed to load pedidos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
      ),
      endDrawer: MenuLateral(),
      body: pedidos.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: pedidos.length,
              itemBuilder: (context, index) {
                Color statusColor;
                switch (pedidos[index].status.toLowerCase()) {
                  case 'aguardando':
                    statusColor = Colors.red;
                    break;
                  case 'preparando':
                    statusColor = Colors.amber;
                    break;
                  case 'finalizado':
                    statusColor = Colors.green;
                    break;
                  default:
                    statusColor = Colors.black;
                }

                return Card(
                  color: const Color(0xff203F97),
                  margin: EdgeInsets.only(
                      left: 16.0, top: 15.0, right: 16.0, bottom: 1.0),
                  child: ListTile(
                    title: Row(
                      children: [
                        Text(
                          'Nº ${pedidos[index].numeroPedido.toString()} - ',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Mesa ${pedidos[index].mesa}',
                          style: TextStyle(color: Colors.white),
                        ),
                        Spacer(), // Adiciona um espaço flexível
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            pedidos[index].status,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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
