import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:async' show Timer;

class Produto {
  final String nome;

  Produto({
    required this.nome,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      nome: json['nome'] ?? "",
    );
  }
}

class ItemPedido {
  final Produto produto;
  final String? nome;
  final int? quantidade;
  final String? observacao;

  ItemPedido({
    required this.produto,
    this.nome,
    this.quantidade,
    this.observacao,
  });

  factory ItemPedido.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> produtoJson = json['produto'] ?? {};
    return ItemPedido(
      observacao: json['observacao'],
      produto: Produto(
        nome: produtoJson['nome'],
      ),
      quantidade: json['quantidade'],
    );
  }
}

class Pedido {
  String id;
  int numeroPedido;
  String mesa;
  String status;
  List<ItemPedido> itens;

  Pedido({
    required this.numeroPedido,
    required this.mesa,
    required this.status,
    required this.itens,
    required this.id,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    List<dynamic> itensJson = json['itens'];
    List<ItemPedido> itens = [];
    if (itensJson != null) {
      itens = itensJson.map((itemJson) {
        return ItemPedido.fromJson(itemJson);
      }).toList();
    }

    return Pedido(
      id: json['id'],
      numeroPedido: json['numeroPedido'],
      mesa: json['mesa'],
      status: json['status'],
      itens: itens,
    );
  }
}

class TelaCozinha extends StatefulWidget {
  const TelaCozinha({super.key});

  @override
  TelaCozinhaState createState() => TelaCozinhaState();
}

class TelaCozinhaState extends State<TelaCozinha> {
  late List<Pedido> pedidos;
  late Timer timer;
  bool nenhumPedidoEncontrado = false;

  @override
  void initState() {
    super.initState();
    pedidos = [];
    timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      fetchPedidos();
      print('Tela atualizada.');
    });
  }

  Future<void> fetchPedidos() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://orderease-api.onrender.com/api/obter-pedidos?status=Preparando&status=Aguardando'),
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          pedidos = jsonResponse.map((data) {
            List<dynamic> itensJson = data['itens'] ?? [];
            List<ItemPedido> itens = itensJson.map<ItemPedido>((item) {
              Map<String, dynamic> produtoJson = item['produto'] ?? {};
              return ItemPedido(
                observacao: item['observacao'],
                produto: Produto(
                  nome: produtoJson['nome'],
                ),
                quantidade: item['quantidade'],
              );
            }).toList();

            return Pedido(
              id: data['id'],
              numeroPedido: data['numeroPedido'],
              mesa: data['mesa'],
              status: data['status'],
              itens: itens,
            );
          }).toList();
          nenhumPedidoEncontrado = false;
        });
      } else if (response.statusCode == 404) {
        // Nenhum pedido encontrado
        setState(() {
          pedidos = [];
          nenhumPedidoEncontrado = true;
        });
      } else {
        print('Failed to load pedidos - Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching pedidos: $e');
    }
  }

  Future<void> atualizarStatusPedido(String id, String novoStatus) async {
    final url = 'https://orderease-api.onrender.com/api/atualizar-pedido/$id';

    try {
      final response = await http.put(
        Uri.parse(url),
        body: jsonEncode({'status': novoStatus}),
        headers: {'Content-Type': 'application/json'},
      );

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

  Future<void> marcarComoPreparando(String id) async {
    await atualizarStatusPedido(id, 'Preparando');
  }

  Future<void> marcarComoFinalizado(String id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text('Deseja marcar o pedido como "Finalizado"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await atualizarStatusPedido(id, 'Finalizado');
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos - Cozinha'),
      ),
      body: nenhumPedidoEncontrado
          ? const Center(
              child: Text(
                'Nenhum pedido encontrado.',
                style: TextStyle(fontSize: 18.0),
              ),
            )
          : pedidos.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.separated(
                  itemCount: pedidos.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      color: Color.fromARGB(255, 0, 0, 0),
                      thickness: 1.2,
                    );
                  },
                  itemBuilder: (context, index) {
                    final pedido = pedidos[index];
                    return Card(
                      color: const Color(0xff0B518A),
                      margin: const EdgeInsets.all(16.0),
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(color: Colors.black),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Nº ${pedido.numeroPedido.toString()} - ',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'Mesa ${pedido.mesa}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      child: Text(
                                        pedido.status,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 1.0),
                                const Divider(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  thickness: 1.2,
                                ),
                                const SizedBox(height: 1.0),
                                const Text(
                                  'Itens:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: pedido.itens.length,
                                  separatorBuilder:
                                      (BuildContext context, int itemIndex) {
                                    return const Divider(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      thickness: 1.2,
                                    );
                                  },
                                  itemBuilder:
                                      (BuildContext context, int itemIndex) {
                                    final item = pedido.itens[itemIndex];
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (item.produto.nome != null &&
                                            item.quantidade != null)
                                          Text(
                                            '  - ${item.produto.nome} (${item.quantidade}x)',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        if (item.observacao != null)
                                          Text(
                                            '    Observação: ${item.observacao}',
                                            style: const TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: Colors.white,
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                            onTap: () {
                              // Adicione aqui o que você quer fazer ao clicar em um pedido
                            },
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  await marcarComoPreparando(pedido.id);
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.orange,
                                  onPrimary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: const Text('Preparando'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  await marcarComoFinalizado(pedido.id);
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                  onPrimary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: const Text('Finalizado'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
