import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

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

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      nome: map['nome'],
      categoria: map['categoria'],
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
      'itens': itens.map((item) => item.toMap()).toList(),
      'mesa': mesa,
      'observacao': observacao,
    };
  }

  factory Pedido.fromMap(Map<String, dynamic> map) {
    var itens =
        (map['itens'] as List).map((item) => ItemPedido.fromMap(item)).toList();
    return Pedido(
      mesa: map['mesa'],
      observacao: map['observacao'],
      itens: itens,
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
    carregarItemsDisponiveis();
    carregarPedidosDoFirebase();
  }

  List<String> categoriasDisponiveis = [];

  Future<void> carregarItemsDisponiveis() async {
    try {
      var querySnapshot =
          await FirebaseFirestore.instance.collection('produtos').get();
      itemsDisponiveis =
          querySnapshot.docs.map((doc) => Produto.fromMap(doc.data())).toList();

      // Obter categorias únicas dos produtos
      categoriasDisponiveis =
          itemsDisponiveis.map((produto) => produto.categoria).toSet().toList();

      setState(() {});
    } catch (e) {
      print('Erro ao carregar itens disponíveis do Firebase: $e');
    }
  }

  static Future<List<Pedido>> carregarPedidosDoFirebase() async {
    try {
      var querySnapshot =
          await FirebaseFirestore.instance.collection('pedidos').get();
      var pedidosCarregados = querySnapshot.docs
          .map((doc) => Pedido.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      return pedidosCarregados;
    } catch (e) {
      print('Erro ao carregar pedidos do Firebase: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Funcionalidades de Pedidos'),
      ),
      body: Padding(
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
            DropdownButton<String>(
              value: selectedCategory,
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                  selectedItemIndex = 0;
                  categoriasDisponiveis = itemsDisponiveis
                      .map((produto) => produto.categoria)
                      .toSet()
                      .toList();
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
            const SizedBox(height: 20),
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
            ElevatedButton(
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

                  // Adicionar um novo item ao pedido existente ou criar um novo pedido
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

                    // Limpar os controladores
                    quantidadeController.clear();
                    observacaoController.clear();
                  });
                } catch (e) {
                  // Tratamento de erros
                  print('Erro ao incluir produto: $e');
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

            // Lista de pedidos
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
                            // Remover o item do pedido
                            pedido.itens.remove(item);

                            // Se não houver mais itens no pedido, remover o pedido
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            print('Botão "Registrar" pressionado');

            // Verificar se há pedidos para registrar
            if (pedidos.isEmpty) {
              print('Nenhum pedido para registrar.');
              return;
            }

            // Enviar pedidos para o Firestore
            for (Pedido pedido in pedidos) {
              await _firestore.collection('pedidos').add(pedido.toMap());
            }

            // Limpar a lista de pedidos após enviar para o Firestore
            setState(() {
              pedidos.clear();
            });

            print('Pedidos registrados com sucesso!');
          } catch (e) {
            // Tratamento de erros
            print('Erro ao registrar pedidos: $e');
          }
        },
        backgroundColor: const Color(0xff0B518A), // Cor de fundo
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

        child: const Text(
          'Registrar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
