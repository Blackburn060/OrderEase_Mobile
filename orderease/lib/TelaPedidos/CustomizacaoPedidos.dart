import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'FuncionalidadesPedidos.dart';

class CustomizacaoPedidos extends StatefulWidget {
  @override
  _CustomizacaoPedidosState createState() => _CustomizacaoPedidosState();
}

class _CustomizacaoPedidosState extends State<CustomizacaoPedidos> {
  TextEditingController quantidadeController = TextEditingController();
  TextEditingController observacaoController = TextEditingController();
  TextEditingController mesaController = TextEditingController();
  String selectedCategory = 'Bebidas Alcoólicas';
  int selectedItemIndex = 0;
  List<Produto> itemsDisponiveis = [
    Produto(nome: 'tomate', categoria: 'Bebidas Alcoólicas'),
    Produto(nome: 'cereja', categoria: 'Bebidas Alcoólicas'),
    Produto(nome: 'caldo', categoria: 'Comida'),
    // Adicione mais itens conforme necessário
  ];
  List<Pedido> pedidos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incluir Produto'),
      ),
      body: Card(
        margin: EdgeInsets.all(16.0), // Ajuste a margem conforme necessário
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
                decoration: const InputDecoration(labelText: 'Observação'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    print('Botão "Incluir Produto" pressionado');
                    if (quantidadeController.text.isEmpty) {
                      throw Exception("A quantidade não pode ser vazia.");
                    }

                    final item = itemsDisponiveis
                        .where((item) => item.categoria == selectedCategory)
                        .elementAt(selectedItemIndex);
                    final quantidade =
                        int.parse(quantidadeController.text);

                    final mesa = mesaController.text;
                    final observacao = observacaoController.text;

                    final pedido = Pedido(
                      produto: item,
                      quantidade: quantidade,
                      mesa: mesa,
                      observacao: observacao,
                    );

                    pedidos.add(pedido);

                    // Limpar os controladores
                    quantidadeController.clear();
                    observacaoController.clear();

                    // Atualizar o estado para reconstruir o widget
                    setState(() {});
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

              // Lista de itens selecionados
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: pedidos.map((pedido) {
                  return ListTile(
                    title: Text(
                      '${pedido.produto.nome} - ${pedido.quantidade}',
                      style: TextStyle(fontSize: 16),
                    ),
                    subtitle: Text(
                      'Mesa: ${pedido.mesa}, Observação: ${pedido.observacao}',
                    ),
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
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // ... Lógica do FloatingActionButton ...
        },
        backgroundColor: const Color(0xff0B518A),
        child: const Text('Registrar'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
