import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:async' show Timer;

class Produto {
  final String nome;
  final String descricao;
  final String categoria;
  final double valor;
  final String status;
  final String imageUri;

  Produto({
    required this.nome,
    required this.descricao,
    required this.categoria,
    required this.valor,
    required this.status,
    required this.imageUri,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      nome: json['nome'] ?? "",
      descricao: json['descricao'] ?? "",
      categoria: json['categoria'] ?? "",
      valor: (json['valor'] ?? 0.0).toDouble(),
      status: json['status'] ?? "",
      imageUri: json['imageUri'] ?? "",
    );
  }
}

class ItemPedido {
  final Produto produto;
  final String? nome;
  final String? descricao;
  final int? quantidade;
  final String? observacao;
  final String? descricaoItem;

  ItemPedido({
    required this.produto,
    this.nome,
    this.descricao,
    this.quantidade,
    this.observacao,
    this.descricaoItem,
  });

  factory ItemPedido.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> produtoJson = json['produto'] ?? {};
    return ItemPedido(
      produto: Produto.fromJson(produtoJson),
      nome: json['nome'],
      descricao: json['descricao'],
      quantidade: json['quantidade'],
      observacao: json['observacao'],
      descricaoItem: json['descricaoItem'],
    );
  }
}

class Pedido {
  int numeroPedido;
  String mesa;
  String status;
  List<ItemPedido> itens;

  Pedido({
    required this.numeroPedido,
    required this.mesa,
    required this.status,
    required this.itens,
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
      numeroPedido: json['numeroPedido'],
      mesa: json['mesa'],
      status: json['status'],
      itens: itens,
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
  late Timer timer;

  @override
  void initState() {
    super.initState();
    pedidos = [];
    timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      fetchPedidos();
      print('Tela atualizada.');
    });
  }

  Future<void> fetchPedidos() async {
    try {
      final response = await http.get(
        Uri.parse('https://orderease-api.onrender.com/api/obter-pedidos'),
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          pedidos = jsonResponse.map((data) {
            if (data['itens'] != null && data['itens'] is List) {
              // Verifica se 'itens' existe e é uma lista
              List<ItemPedido> itens =
                  (data['itens'] as List).map<ItemPedido>((item) {
                Map<String, dynamic> produtoJson = item['produto'] ?? {};
                return ItemPedido.fromJson(item);
              }).toList();
              return Pedido(
                numeroPedido: data['numeroPedido'],
                mesa: data['mesa'],
                status: data['status'],
                itens: itens,
              );
            } else {
              return Pedido(
                numeroPedido: data['numeroPedido'],
                mesa: data['mesa'],
                status: data['status'],
                itens: [], // Se 'itens' não existir ou não for uma lista, cria uma lista vazia
              );
            }
          }).toList();
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

  Future<void> marcarComoPreparando(int index) async {
    setState(() {
      pedidos[index].status = 'Preparando';
    });

    await atualizarStatusPedido(
        pedidos[index].numeroPedido.toString(), 'Preparando');
  }

  @override
  void dispose() {
    timer
        .cancel(); // Cancela o timer ao sair da tela para evitar vazamentos de recursos
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos - Cozinha'),
      ),
      body: pedidos.isEmpty
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
                return Card(
                  color: const Color(0xff0B518A),
                  margin: EdgeInsets.all(16.0),
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: Colors.black),
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
                                  'Nº ${pedidos[index].numeroPedido.toString()} - ',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  'Mesa ${pedidos[index].mesa}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Text(
                                    pedidos[index].status,
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
                            // Adiciona um ListView separado para os itens
                            ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: pedidos[index].itens.length,
                              separatorBuilder:
                                  (BuildContext context, int itemIndex) {
                                return const Divider(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  thickness: 1.2,
                                );
                              },
                              itemBuilder:
                                  (BuildContext context, int itemIndex) {
                                final item = pedidos[index].itens[itemIndex];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (item.produto.nome != null &&
                                        item.quantidade != null)
                                      Text(
                                        '  - ${item.produto.nome} (${item.quantidade}x)',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    if (item.observacao != null)
                                      Text(
                                        '    Observação: ${item.observacao}',
                                        style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.white,
                                        ),
                                      ),
                                    if (item.descricaoItem != null)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 16.0,
                                        ),
                                        child: Text(
                                          '    Descrição do Item: ${item.descricaoItem}',
                                          style: const TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: Colors.white,
                                          ),
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
                              // Lógica para marcar como "Preparando"
                              await marcarComoPreparando(index);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.orange,
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text('Preparando'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              // Exibe uma mensagem de confirmação antes de alterar o status
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Confirmar'),
                                    content: Text(
                                        'Deseja marcar o pedido como "Finalizado"?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Fecha o diálogo
                                        },
                                        child: Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          // Lógica para marcar como "Finalizado"
                                          setState(() {
                                            pedidos[index].status =
                                                'Finalizado';
                                          });

                                          // Atualiza o status no banco de dados
                                          await atualizarStatusPedido(
                                              pedidos[index]
                                                  .numeroPedido
                                                  .toString(), // Converte para String
                                              'Finalizado');

                                          Navigator.of(context)
                                              .pop(); // Fecha o diálogoálogo
                                        },
                                        child: Text('Confirmar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text('Finalizado'),
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
