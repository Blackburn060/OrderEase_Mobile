/*  import 'package:flutter/material.dart';
import '../TelaPedidos/FuncionalidadesPedidos.dart';

class TelaCozinha extends StatefulWidget {
  final List<Pedido> pedidos;

  TelaCozinha({required this.pedidos});

  @override
  TelaCozinhaState createState() => TelaCozinhaState();
}

class TelaCozinhaState extends State<TelaCozinha> {
  late List<Pedido> pedidos;

  @override
  void initState() {
    super.initState();
    pedidos = widget.pedidos; // Atribua os pedidos do widget à variável local
  }

  Future<void> carregarPedidosDoFirebase() async {
    try {
      var pedidosCarregados =
          await FuncionalidadesPedidos.carregarPedidosDoFirebase();
      setState(() {
        pedidos = pedidosCarregados;
      });
    } catch (e) {
      print('Erro ao carregar pedidos na cozinha: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cozinha'),
      ),
      body: FutureBuilder<void>(
        future: carregarPedidosDoFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Erro ao carregar pedidos: ${snapshot.error}'),
              );
            } else {
              return _buildPedidosList();
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildPedidosList() {
    if (pedidos.isEmpty) {
      return Center(
        child: Text('Não há pedidos na cozinha.'),
      );
    } else {
      return ListView.builder(
        itemCount: pedidos.length,
        itemBuilder: (context, index) {
          final pedido = pedidos[index];
          return _buildPedidoCard(pedido);
        },
      );
    }
  }

  Widget _buildPedidoCard(Pedido pedido) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mesa: ${pedido.mesa}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Observação: ${pedido.observacao}',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            'Itens do Pedido:',
            style: const TextStyle(color: Colors.white),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: pedido.itens.map((item) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Produto: ${item.produto.nome}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Quantidade: ${item.quantidade}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Observação: ${item.observacao}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
  */