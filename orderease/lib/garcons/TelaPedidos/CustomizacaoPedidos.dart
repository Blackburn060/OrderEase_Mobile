// customizacao_pedidos.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Adicione esta linha

class CustomizacaoPedidos {
  static ElevatedButton buildCustomElevatedButton({
    required VoidCallback onPressed,
    required String buttonText,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 138, 34, 11),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: const Size(160, 50),
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static Widget buildTextField({
    required TextEditingController controller,
    required TextInputType keyboardType,
    required List<TextInputFormatter> inputFormatters,
    required String labelText,
    required String hintText,
  }) {
    return SizedBox(
      width: 150,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
        ),
      ),
    );
  }

  // Adicione esta função
  static AppBar buildAppBar(String title) {
    return AppBar(
      title: Text(title),
    );
  }

  static Widget buildTextFieldQuantidade({
    required TextEditingController controller,
  }) {
    return CustomizacaoPedidos.buildTextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      labelText: 'Quantidade',
      hintText: 'Digite a quantidade',
    );
  }

  static Widget buildScaffoldBody(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
