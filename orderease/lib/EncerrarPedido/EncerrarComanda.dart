import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EncerrarPedidos extends StatelessWidget {
  final String mesa;

  const EncerrarPedidos({super.key, required this.mesa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff203F97),
        title: const Center(
          child: Text(
            'Encerrar Pedidos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container mostrando o número da mesa
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Mesa:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {}, // Adicione a lógica desejada aqui
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black, backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: const BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        mesa,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder(
              future: FirebaseFirestore.instance.collection('pedidos')
                  .where('pago', isEqualTo: 'Não')
                  .where('mesa', isEqualTo: mesa.toString())
                  .get(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text('Erro: ${snapshot.error}');
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text('Nenhum pedido encontrado.');
                }

                List<Map<String, dynamic>> pedidosData = [];

                for (var doc in snapshot.data!.docs) {
                  var itens = doc['itens'];

                  pedidosData.add({
                    'itens': itens,
                  });
                }

                return Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        _buildDataTable(pedidosData),
                        const SizedBox(height: 20),
                        _buildTotalField(pedidosData),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
        onPressed: () {
          _encerrarComanda(context);
          _atualizarStatusPago();
        },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20), backgroundColor: const Color(0xff203F97),
                minimumSize: const Size(double.infinity, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Encerrar Comanda',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Widget _buildDataTable(List<Map<String, dynamic>> pedidosData) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Quantidade')),
        DataColumn(label: Text('Item')),
        DataColumn(label: Text('Valor')),
      ],
      rows: pedidosData.map((pedido) {
        List<dynamic> itens = pedido['itens'];

        final rows = itens.map<DataRow>((item) {
          return DataRow(
            cells: [
              DataCell(Text(item['quantidade'].toString())),
              DataCell(Text(item['produto']['nome'].toString()),),
              DataCell(Text(
                'R\$ ${item['produto']['valor'].toStringAsFixed(2)}',
              )),
            ],
          );
        }).toList();
        return rows;
      }).expand((i) => i).toList(),
    );
  }

  Widget _buildTotalField(List<Map<String, dynamic>> pedidosData) {
    double total = 0.0;
    for (var pedido in pedidosData) {
      List<dynamic> itens = pedido['itens'];
      for (var item in itens) {
        total += item['quantidade'] * item['produto']['valor'];
      }
    }

    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: const EdgeInsets.only(top: 20, right: 20),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Total:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: const Color(0xff0B518A),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                'R\$ ${NumberFormat("#,##0.00", "pt_BR").format(total)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
void _atualizarStatusPago() async {
    try {
      CollectionReference pedidosCollection =
          FirebaseFirestore.instance.collection('pedidos');
      await pedidosCollection
          .where('mesa', isEqualTo: mesa)
          .where('pago', isEqualTo: 'Não')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          pedidosCollection.doc(doc.id).update({'pago': 'Sim'});
        });
      });
    } catch (error) {
      print('Erro: $error');
    }
  }
  void _encerrarComanda(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Comanda encerrada com sucesso!'),
      ),
    );
  }
}