import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EncerrarPedidos extends StatelessWidget {
  final int mesa;

  const EncerrarPedidos({Key? key, required this.mesa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff203F97),
        title: Text(
          'Encerrar Pedidos - Mesa $mesa',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Adiciona a tabela no corpo da tela
            FutureBuilder(
              future: FirebaseFirestore.instance.collection('pedidos').get(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text('Erro: ${snapshot.error}');
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text('Nenhum pedido encontrado.');
                }

                List<Map<String, dynamic>> pedidosData = [];

                snapshot.data!.docs.forEach((doc) {
                  var numeroPedido = doc['numeroPedido'];
                  var mesa = doc['mesa'];
                  var status = doc['status'];
                  var itens = doc['itens'];

                  // Adiciona os dados do pedido à lista
                  pedidosData.add({
                    'numeroPedido': numeroPedido,
                    'mesa': mesa,
                    'status': status,
                    'itens': itens,
                  });
                });

                return Expanded(
                  child: _buildDataTable(pedidosData),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Lógica para encerrar a comanda
                _encerrarComanda(context);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(20),
                minimumSize: const Size(double.infinity, 0),
                primary: const Color(0xff0B518A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Encerrar Comanda',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  // Método para criar a tabela
  Widget _buildDataTable(List<Map<String, dynamic>> pedidosData) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Número Pedido')),
        DataColumn(label: Text('Mesa')),
        DataColumn(label: Text('Status')),
        DataColumn(label: Text('itens')),
      ],
      rows: pedidosData.map((pedido) {
        return DataRow(
          cells: [
            DataCell(Text(pedido['numeroPedido'].toString())),
            DataCell(Text(pedido['mesa'])),
            DataCell(Text(pedido['status'])),
            DataCell(Text(pedido['itens'].toString())),
          ],
        );
      }).toList(),
    );
  }

  void _encerrarComanda(BuildContext context) {
    // Implemente a lógica para encerrar a comanda aqui
    // Pode incluir a atualização do status do pedido, etc.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Comanda encerrada com sucesso!'),
      ),
    );
  }
}
