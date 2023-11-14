import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'CustomizacaoPedidos.dart';

class Produto {
  final String nome;
  final String categoria;

  Produto({required this.nome, required this.categoria});

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'categoria': categoria,
    };
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
}

class Pedido {
  final String mesa;
  final String observacao;
  final List<ItemPedido> itens;

  Pedido({
    required this.mesa,
    required this.observacao,
    required this.itens,
  });

  Map<String, dynamic> toMap() {
    return {
      'itens': itens.map((item) => item.toMap()).toList(), // Correção aqui
      'mesa': mesa,
      'observacao': observacao,
    };
  }
}

class FuncionalidadesPedidos extends StatefulWidget {
  const FuncionalidadesPedidos({Key? key}) : super(key: key);

  @override
  _FuncionalidadesPedidosState createState() => _FuncionalidadesPedidosState();
}

class _FuncionalidadesPedidosState extends State<FuncionalidadesPedidos> {
  final TextEditingController quantidadeController = TextEditingController();
  final TextEditingController mesaController = TextEditingController();
  final TextEditingController observacaoController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Produto> itemsDisponiveis = [
    Produto(nome: 'tomate', categoria: 'Bebidas Alcoólicas'),
    Produto(nome: 'cereja', categoria: 'Bebidas Alcoólicas'),
    Produto(nome: 'caldo', categoria: 'Comida'),
    // Adicione mais itens conforme necessário
  ];

  String selectedCategory = 'Bebidas Alcoólicas';
  int selectedItemIndex = 0;
  List<Pedido> pedidos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomizacaoPedidos.buildAppBar('Funcionalidades de Pedidos'),
      body: CustomizacaoPedidos.buildScaffoldBody(
        <Widget>[
          const SizedBox(height: 20),
          CustomizacaoPedidos.buildTextField(
            controller: mesaController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            labelText: 'Mesa',
            hintText: 'Digite o número da mesa',
          ),
          const SizedBox(height: 20),
          DropdownButton<String>(
            value: selectedCategory,
            onChanged: (value) {
              setState(() {
                selectedCategory = value!;
                selectedItemIndex = 0;
              });
            },
            items: itemsDisponiveis
                .map((item) => item.categoria)
                .toSet()
                .toList()
                .map((category) {
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
          const SizedBox(height: 20),
          CustomizacaoPedidos.buildTextField(
            controller: quantidadeController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            labelText: 'Quantidade',
            hintText: 'Digite a quantidade',
          ),
          const SizedBox(height: 20),
          TextField(
            controller: observacaoController,
            decoration: const InputDecoration(labelText: 'Observação'),
          ),
          const SizedBox(height: 20),
          CustomizacaoPedidos.buildCustomElevatedButton(
            onPressed: () {
              try {
                print('Botão "Incluir Produto" pressionado');
                if (quantidadeController.text.isEmpty) {
                  throw Exception("A quantidade não pode ser vazia.");
                }

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

                var pedidoExistente = pedidos.firstWhere(
                  (pedido) => pedido.mesa == mesaController.text,
                  orElse: () => Pedido(
                      itens: [], mesa: mesaController.text, observacao: ''),
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
            },
            buttonText: 'Incluir',
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: pedidos.map((pedido) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: pedido.itens.map((item) {
                  return ListTile(
                    title: Text(
                      '${item.produto.nome} - ${item.quantidade}',
                      style: TextStyle(fontSize: 16),
                    ),
                    subtitle: Text(
                      'Mesa: ${pedido.mesa}, Observação: ${pedido.observacao}',
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
                  );
                }).toList(),
              );
            }).toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            print('Botão "Registrar" pressionado');

            if (pedidos.isEmpty) {
              print('Nenhum pedido para registrar.');
              return;
            }

            for (Pedido pedido in pedidos) {
              await _firestore.collection('pedidos').add(pedido.toMap());
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
        child: const Text('Registrar'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}