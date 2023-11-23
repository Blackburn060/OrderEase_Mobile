import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:orderease/MenuLateral.dart';

class Produto {
  final String nome;
  final String categoria;
  final double valor;

  Produto({required this.nome, required this.categoria, required dynamic valor})
      : valor = _parseDouble(valor);

  static double _parseDouble(dynamic value) {
    if (value is double) {
      return value;
    } else if (value is int) {
      return value.toDouble();
    } else if (value is String) {
      return double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
    } else {                                                      
      return 0.0;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'categoria': categoria,
      'valor': valor,
    };
  }

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      nome: map['nome'],
      categoria: map['categoria'],
      valor: map['valor'] ?? 0.0,
    );
  }
}

class ItemPedido {
  final Produto produto;
  final int quantidade;
  final String observacao;

  ItemPedido({
    required this.produto,
    required this.quantidade,
    required this.observacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'produto': produto.toMap(),
      'quantidade': quantidade,
      'observacao': observacao,
    };
  }

  factory ItemPedido.fromMap(Map<String, dynamic> map) {
    return ItemPedido(
      produto: Produto.fromMap(map['produto']),
      quantidade: map['quantidade'],
      observacao: map['observacao'],
    );
  }
}

class Pedido {
  static int _proximoNumeroPedido = 1;

  final int numeroPedido;
  final String mesa;
  final String observacao;
  final List<ItemPedido> itens;
  final String status;
  double valorTotal;

  Pedido._internal({
    required this.numeroPedido,
    required this.mesa,
    required this.observacao,
    required this.itens,
    this.status = 'Aguardando',
    this.valorTotal = 0.0,
  });

  factory Pedido.fromFirestore(Map<String, dynamic> map) {
    return Pedido._internal(
      numeroPedido: map['numeroPedido'],
      mesa: map['mesa'],
      observacao: map['observacao'],
      itens: (map['itens'] as List)
          .map((item) => ItemPedido.fromMap(item))
          .toList(),
      status: map['status'] ?? 'aguardando',
      valorTotal: 0.0,
    );
  }

  static Future<int> getProximoNumeroPedido() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('pedidos').get();

    if (querySnapshot.docs.isNotEmpty) {
      final ultimaPedido = querySnapshot.docs.last.data();
      return ultimaPedido['numeroPedido'] + 1;
    } else {
      return 1;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'numeroPedido': numeroPedido,
      'itens': itens.map((item) => item.toMap()).toList(),
      'mesa': mesa,
      'status': status,
    };
  }

  factory Pedido.fromMap(Map<String, dynamic> map) {
    var itens =
        (map['itens'] as List).map((item) => ItemPedido.fromMap(item)).toList();
    return Pedido._internal(
      numeroPedido: map['numeroPedido'],
      mesa: map['mesa'],
      observacao: map['observacao'],
      itens: itens,
      status: map['status'] ?? 'aguardando',
      valorTotal: 0.0,
    );
  }
}

class FuncionalidadesPedidos extends StatefulWidget {
  const FuncionalidadesPedidos({Key? key}) : super(key: key);

  @override
  FuncionalidadesPedidosState createState() => FuncionalidadesPedidosState();
}

class FuncionalidadesPedidosState extends State<FuncionalidadesPedidos> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController quantidadeController = TextEditingController();
  TextEditingController mesaController = TextEditingController();
  TextEditingController observacaoController = TextEditingController();

  List<Produto> itemsDisponiveis = [];

  String selectedCategory = 'Bebidas Alcoólicas';
  int selectedItemIndex = 0;
  List<Pedido> pedidos = [];

  @override
  void initState() {
    super.initState();
    carregarProdutosDaAPI();
  }

  List<String> categoriasDisponiveis = [];

  Future<void> carregarProdutosDaAPI() async {
    try {
      final response = await http.get(Uri.parse(
          'https://orderease-api.onrender.com/api/listar-produtos?status=Ativo'));

      if (response.statusCode == 200) {
        final List<dynamic> produtosJson = json.decode(response.body);

        itemsDisponiveis = produtosJson.map((produto) {
          final valor = produto['valor'];
          print('Valor bruto da API: $valor');
          return Produto(
            nome: produto['nome'],
            categoria: produto['categoria'],
            valor: valor,
          );
        }).toList();
        categoriasDisponiveis = itemsDisponiveis
            .map((produto) => produto.categoria)
            .toSet()
            .toList();

        setState(() {});
      } else {
        print('Erro ao carregar produtos da API: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar produtos da API: $e');
    }
  }

  ElevatedButton buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff0B518A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: const Size(200, 50),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Registro de Pedido'),
        backgroundColor: const Color(0xff0B518A),
      ),
      // endDrawer: MenuLateral(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 1),
            SizedBox(
              width: 60,
              child: TextField(
                controller: mesaController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: const InputDecoration(
                  labelText: 'Mesa',
                  hintText: 'Digite o número da mesa',
                ),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: categoriasDisponiveis.contains(selectedCategory)
                  ? selectedCategory
                  : categoriasDisponiveis.isNotEmpty
                      ? categoriasDisponiveis[0]
                      : '',
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                  selectedItemIndex = 0;
                });
              },
              items: categoriasDisponiveis.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            DropdownButton<int>(
              value: selectedItemIndex,
              onChanged: (value) {
                setState(() {
                  selectedItemIndex = value!;
                });
              },
              items: List.generate(
                itemsDisponiveis
                    .where((item) => item.categoria == selectedCategory)
                    .length,
                (index) => DropdownMenuItem<int>(
                  value: index,
                  child: Text(
                    itemsDisponiveis
                        .where((item) => item.categoria == selectedCategory)
                        .elementAt(index)
                        .nome,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: quantidadeController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                labelText: 'Quantidade',
                hintText: 'Digite a quantidade',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
              ),
            ),
            const SizedBox(height: 25),
            TextField(
              controller: observacaoController,
              decoration: InputDecoration(
                labelText: 'Observação',
                hintText: 'Digite uma observação',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              alignment: Alignment.centerRight,
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: 170, height: 50),
                child: buildButton('Incluir Produto', () async {
                  try {
                    print('Botão "Incluir Produto" pressionado');
                    if (quantidadeController.text.isEmpty) {
                      throw Exception("A quantidade não pode ser vazia.");
                    }

                    var proximoNumeroPedido =
                        await Pedido.getProximoNumeroPedido();
                    var pedidoExistente = pedidos.firstWhere(
                      (pedido) => pedido.mesa == mesaController.text,
                      orElse: () {
                        var novoPedido = Pedido._internal(
                          numeroPedido: proximoNumeroPedido,
                          mesa: mesaController.text,
                          observacao: '',
                          itens: [],
                        );
                        pedidos.add(novoPedido);
                        return novoPedido;
                      },
                    );

                    final item = itemsDisponiveis
                        .where((item) => item.categoria == selectedCategory)
                        .elementAt(selectedItemIndex);
                    final quantidade = int.parse(quantidadeController.text);

                    final observacao = observacaoController.text;

                    final itemPedido = ItemPedido(
                      produto: item,
                      quantidade: quantidade,
                      observacao: observacao,
                    );

                    setState(() {
                      pedidoExistente.itens.add(itemPedido);

                      if (!pedidos.contains(pedidoExistente)) {
                        pedidos.add(pedidoExistente);
                      }

                      quantidadeController.clear();
                      observacaoController.clear();
                    });
                  } catch (e) {
                    print('Erro ao incluir produto: $e');
                  }
                }),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: pedidos.length,
                itemBuilder: (context, index) {
                  final pedido = pedidos[index];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...pedido.itens.map((item) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(
                                '${item.produto.nome}',
                                style: TextStyle(fontSize: 16),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Quantidade: ${item.quantidade}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  if (item.observacao.isNotEmpty)
                                    Text(
                                      'Observação: ${item.observacao}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  Text(
                                    'Mesa: ${pedido.mesa}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    pedido.itens.remove(item);

                                    if (pedido.itens.isEmpty) {
                                      pedidos.remove(pedido);
                                    }
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        );
                      }).toList(),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 120.0,
        child: FloatingActionButton(
          onPressed: () async {
            try {
              print('Botão "Registrar" pressionado');

              if (pedidos.isEmpty) {
                print('Nenhum pedido para registrar.');
                return;
              }

              for (Pedido pedido in pedidos) {
                await _firestore.collection('pedidos').add({
                  ...pedido.toMap(),
                  'numeroPedido': pedido.numeroPedido,
                });
              }

              setState(() {
                pedidos.clear();
              });

              print('Pedidos registrados com sucesso!');
            } catch (e) {
              print('Erro ao registrar pedidos: $e');
            }
          },
          backgroundColor: const Color(0xff0B518A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Registrar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
