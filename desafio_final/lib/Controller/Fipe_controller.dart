import 'package:http/http.dart' as http;
import 'dart:convert';

class FipeController {
  String typeSelected = 'carros';
  VehicleBrand? brandSelected;

  Future<List<VehicleBrand>> getBrands() async {
    final url = 'https://parallelum.com.br/fipe/api/v1/$typeSelected/marcas';
    print('Fetching brands from URL: $url');

    try {
      final response = await http.get(Uri.parse(url));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => VehicleBrand.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load brands');
      }
    } catch (e) {
      print('Error fetching brands: $e');
      throw Exception('Failed to load brands');
    }
  }

  Future<List<VehicleModel>> getModels(String brandCode) async {
    final url = 'https://parallelum.com.br/fipe/api/v1/carros/marcas/$brandCode/modelos';
    print('Fetching models from URL: $url');

    try {
      final response = await http.get(Uri.parse(url));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        List<dynamic> modelos = data['modelos'];
        return modelos.map((item) => VehicleModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load models');
      }
    } catch (e) {
      print('Error fetching models: $e');
      throw Exception('Failed to load models');
    }
  }
}

class VehicleBrand {
  final String code;
  final String name;

  VehicleBrand({
    required this.code,
    required this.name,
  });

  factory VehicleBrand.fromJson(Map<String, dynamic> json) {
    return VehicleBrand(
      code: json['codigo'].toString(),
      name: json['nome'],
    );
  }

  @override
  String toString() {
    return name;
  }
}

class VehicleModel {
  final String code;
  final String name;

  VehicleModel({
    required this.code,
    required this.name,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      code: json['codigo'].toString(),
      name: json['nome'],
    );
  }

  @override
  String toString() {
    return name;
  }
}
