import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CepController extends ChangeNotifier {
  bool _cepValid = false;
  String _message = '';
  Map<String, dynamic>? _cepData;

  /// Retorna se o CEP é válido
  bool get isCepValid => _cepValid;
  /// Retorna a mensagem de status
  String get message => _message;
  /// Retorna os dados do CEP
  Map<String, dynamic>? get cepData => _cepData;

  /// Valida o CEP informado consultando a API
  Future<void> validateCep(String cep) async {
    final url = Uri.parse('https://brasilapi.com.br/api/cep/v1/$cep');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _cepValid = true;
        _message = 'CEP válido';
        _cepData = data;
      } else if (response.statusCode == 404) {
        _cepValid = false;
        _message = 'CEP inválido';
      } else {
        _cepValid = false;
        _message = 'Erro na validação do CEP';
      }
    } catch (e) {
      _cepValid = false;
      _message = 'Erro: $e';
    }

    notifyListeners();
  }
}
