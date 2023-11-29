import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const Color colorPrimary = Color(0xff203F97);
const Color colorRed = Colors.red;
const Color colorAmber = Colors.amber;
const Color colorGreen = Colors.green;

class Pedido {
  final int numeroPedido;
  final String mesa;
  final String status;
  final List<Map<String, dynamic>> itens;
  final String id;

  Pedido({
    required this.numeroPedido,
    required this.mesa,
    required this.status,
    required this.itens,
    required this.id,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      numeroPedido: json['numeroPedido'],
      mesa: json['mesa'],
      status: json['status'],
      itens: List<Map<String, dynamic>>.from(json['itens']),
      id: json['id'],
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
    try {
      final response = await http.get(
          Uri.parse('https://orderease-api.up.railway.app/api/obter-pedidos?status=Aguardando&status=Preparando&status=Finalizado'));
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          pedidos = jsonResponse.map((data) => Pedido.fromJson(data)).toList();
        });
        print('Lista de pedidos atualizada com sucesso.');
      } else {
        throw Exception(
            'Failed to load pedidos. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar pedidos: $e');
    }
  }

  Future<void> atualizarStatusPedido(String id, String novoStatus) async {
    final url = 'https://orderease-api.up.railway.app/api/atualizar-pedido/$id';

    try {
      final response = await http.put(
        Uri.parse(url),
        body: jsonEncode({'status': novoStatus}),
        headers: {'Content-Type': 'application/json'},
      );

      print('Enviando solicitação de atualização de status para o pedido $id...');
      print('Resposta recebida: ${response.body}');

      if (response.statusCode == 200) {
        print('Status do pedido atualizado com sucesso.');
      } else {
        print(
            'Falha ao atualizar o status do pedido - Status Code: ${response.statusCode}');
        print('Corpo da resposta: ${response.body}');
      }
    } catch (e) {
      print('Erro ao atualizar o status do pedido: $e');
    }
  }

  Future<void> marcarComoCancelado(String id) async {
    print('Marcando pedido como Cancelado: $id');
    await atualizarStatusPedido(id, 'Cancelado');
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
      ),
      body: pedidos.isEmpty
          ? Center(
              child: Text(
                'Não há pedidos disponíveis.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: pedidos.length,
              itemBuilder: (context, index) {
                Color statusColor;
                switch (pedidos[index].status.toLowerCase()) {
                  case 'aguardando':
                    statusColor = colorRed;
                    break;
                  case 'preparando':
                    statusColor = colorAmber;
                    break;
                  case 'finalizado':
                    statusColor = colorGreen;
                    break;
                  default:
                    statusColor = Colors.black;
                }

                return Card(
                  color: colorPrimary,
                  margin: EdgeInsets.only(
                    left: 16.0,
                    top: 15.0,
                    right: 16.0,
                    bottom: 1.0,
                  ),
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
                        Spacer(),
                        if (pedidos[index].status.toLowerCase() == 'aguardando')
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Excluir Pedido'),
                                    content: Text(
                                        'Tem certeza de que deseja excluir este pedido?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          // Chamando a função marcarComoCancelado diretamente
                                          marcarComoCancelado(pedidos[index].id);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Sim'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancelar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                        GestureDetector(
                          onTap: () {
                            // Chamando a função marcarComoCancelado diretamente
                            marcarComoCancelado(pedidos[index].id);
                          },
                          child: Container(
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