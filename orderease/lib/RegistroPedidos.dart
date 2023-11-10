import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class RegistroPedidos extends StatefulWidget {
  const RegistroPedidos({Key? key}) : super(key: key);

  @override
  _RegistroPedidosState createState() => _RegistroPedidosState();
}

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

class Pedido {
  final Produto produto;
  final int quantidade;

  Pedido({required this.produto, required this.quantidade});

  Map<String, dynamic> toMap() {
    return {
      'produto': produto.toMap(),
      'quantidade': quantidade,
    };
  }
}

class _RegistroPedidosState extends State<RegistroPedidos> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Produto> itemsDisponiveis = [
    Produto(nome: 'tomate', categoria: 'Bebidas Alcoólicas'),
    Produto(nome: 'cereja', categoria: 'Bebidas Alcoólicas'),
    Produto(nome: 'caldo', categoria: 'Comida'),
    // Adicione mais itens conforme necessário
  ];

  String selectedCategory = 'Bebidas Alcoólicas';
  int selectedItemIndex = 0;
  TextEditingController quantidadeController = TextEditingController();
  TextEditingController observacaoController = TextEditingController();
  TextEditingController mesaController = TextEditingController();
  bool mesaSelecionada = false;
  bool dadosMesaCarregados = false;

  List<Pedido> pedidos = [];

  @override
  void initState() {
    super.initState();
    // Carregar dados da mesa ao iniciar a tela
    _loadMesaData();
  }

  // Função para carregar dados da mesa
  Future<void> _loadMesaData() async {
    try {
      DocumentSnapshot document = await _firestore
          .collection('mesas')
          .doc(mesaController.text)
          .get();
      setState(() {
        mesaSelecionada = document.exists;
        dadosMesaCarregados = true;
      });
    } catch (e) {
      print("Erro ao carregar dados da mesa: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff203F97),
        title: const Text(
          'Incluir Produto',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                SizedBox(
                  width: 150,
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
                const SizedBox(height: 20),
                // Exibir uma mensagem enquanto os dados da mesa estão sendo carregados
                dadosMesaCarregados
                    ? Column(
                        children: [
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
                                  .where((item) =>
                                      item.categoria == selectedCategory)
                                  .length,
                              (index) => DropdownMenuItem<int>(
                                value: index,
                                child: Text(
                                  itemsDisponiveis
                                      .where((item) =>
                                          item.categoria == selectedCategory)
                                      .elementAt(index)
                                      .nome,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: quantidadeController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: const InputDecoration(
                              labelText: 'Quantidade',
                              hintText: 'Digite a quantidade',
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: observacaoController,
                            decoration:
                                const InputDecoration(labelText: 'Observação'),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                if (!mesaSelecionada) {
                                  // Adicione a mesa ao Firestore
                                  await _firestore.collection('mesas').doc(mesaController.text).set({
                                    'numero': int.parse(mesaController.text),
                                  });
                                  setState(() {
                                    mesaSelecionada = true;
                                  });
                                }

                                if (quantidadeController.text.isEmpty) {
                                  throw Exception(
                                      "A quantidade não pode ser vazia.");
                                }

                                final item = itemsDisponiveis
                                    .where((item) =>
                                        item.categoria == selectedCategory)
                                    .elementAt(selectedItemIndex);
                                final quantidade =
                                    int.parse(quantidadeController.text);

                                final pedido = Pedido(
                                    produto: item, quantidade: quantidade);
                                pedidos.add(pedido);

                                // Adicione o pedido ao Firestore
                                await _firestore
                                    .collection('pedidos')
                                    .add(pedido.toMap());

                                // Limpar os campos após adicionar um produto
                                quantidadeController.clear();
                                observacaoController.clear();
                              } catch (e) {
                                print("Erro ao adicionar produto: $e");
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff0B518A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minimumSize: const Size(200, 50),
                            ),
                            child: const Text(
                              'Incluir Produto',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Column(
                            children: pedidos.map((pedido) {
                              return ListTile(
                                title: Text(
                                    '${pedido.produto.nome} - ${pedido.quantidade}'),
                                subtitle: Text(pedido.produto.categoria),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      pedidos.remove(pedido);
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      )
                    : const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            if (!mesaSelecionada) {
              throw Exception(
                  "Selecione a mesa antes de adicionar produtos.");
            }
            if (quantidadeController.text.isEmpty) {
              throw Exception("A quantidade não pode ser vazia.");
            }

            final item = itemsDisponiveis
                .where((item) => item.categoria == selectedCategory)
                .elementAt(selectedItemIndex);
            final quantidade = int.parse(quantidadeController.text);

            final pedido = Pedido(produto: item, quantidade: quantidade);
            pedidos.add(pedido);

            // Adicione o pedido ao Firestore
            await _firestore.collection('pedidos').add(pedido.toMap());

            // Limpar os campos após adicionar um produto
            quantidadeController.clear();
            observacaoController.clear();
          } catch (e) {
            print("Erro ao adicionar produto: $e");
          }
        },
        backgroundColor: const Color(0xff0B518A),
        child: const Text('Registrar'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
