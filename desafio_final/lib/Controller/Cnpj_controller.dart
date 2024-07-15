import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CnpjController with ChangeNotifier {
  late bool _cnpjValid;
  String _message = '';

  /// Retorna se o CNPJ é válido
  bool get isCnpjValid => _cnpjValid;
  /// Retorna a mensagem de status
  String get message => _message;

  /// Valida o CNPJ informado consultando a API e compara o estado
  Future<void> validateCnpjAndState(String cnpj, String state) async {
    try {
      final response = await http.get(Uri.parse('https://brasilapi.com.br/api/cnpj/v1/$cnpj'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final apiState = jsonData['uf'];

        if (apiState == state) {
          _cnpjValid = true;
          _message = 'CNPJ e estado válidos!';
        } else {
          _cnpjValid = false;
          _message = 'CNPJ válido, mas o estado não corresponde!';
        }
      } else if (response.statusCode == 404) {
        _cnpjValid = false;
        _message = 'CNPJ inválido';
      } else {
        _cnpjValid = false;
        _message = 'Erro na validação do CNPJ';
      }
    } catch (e) {
      _cnpjValid = false;
      _message = 'Erro: $e';
    }

    notifyListeners();
  }
}
