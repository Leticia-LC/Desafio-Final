import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../Model/Database.dart';
import '../Model/Veiculo.dart';

class CadastroVeiculosScreen extends StatefulWidget {
  @override
  _CadastroVeiculosScreenState createState() => _CadastroVeiculosScreenState();
}

class _CadastroVeiculosScreenState extends State<CadastroVeiculosScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  late TextEditingController _marcaController;
  late TextEditingController _modeloController;
  late TextEditingController _placaController;
  late TextEditingController _anoFabricacaoController;
  late TextEditingController _custoController;

  @override
  void initState() {
    super.initState();
    _marcaController = TextEditingController();
    _modeloController = TextEditingController();
    _placaController = TextEditingController();
    _anoFabricacaoController = TextEditingController();
    _custoController = TextEditingController();
  }

  @override
  void dispose() {
    _marcaController.dispose();
    _modeloController.dispose();
    _placaController.dispose();
    _anoFabricacaoController.dispose();
    _custoController.dispose();
    super.dispose();
  }

  void _saveVeiculo() async {
    if (_formKey.currentState!.validate()) {
      Veiculo veiculo = Veiculo(
        marca: _marcaController.text,
        modelo: _modeloController.text,
        placa: _placaController.text,
        anoFabricacao: int.parse(_anoFabricacaoController.text),
        custo: int.parse(_custoController.text),
      );

      await _dbHelper.saveVeiculo(veiculo);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veículo cadastrado com sucesso!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Cadastro de Veículo'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Marca',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                TextFormField(
                  controller: _marcaController,
                  decoration: InputDecoration(
                    hintText: "marca",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a marca do veículo';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Text(
                  'Modelo',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                TextFormField(
                  controller: _modeloController,
                  decoration: InputDecoration(
                    hintText: "modelo",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o modelo do veículo';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Text(
                  'Placa',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                TextFormField(
                  controller: _placaController,
                  decoration: InputDecoration(
                    hintText: "XXX-0000",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a placa do veículo';
                    }
                    return null;
                  },
                  inputFormatters: [
                    MaskTextInputFormatter(mask: '###-####'),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Ano de Fabricação',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                TextFormField(
                  controller: _anoFabricacaoController,
                  decoration: InputDecoration(
                    hintText: "0000",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o ano de fabricação do veículo';
                    }
                    return null;
                  },
                  inputFormatters: [
                    MaskTextInputFormatter(mask: '####'),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Custo',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                TextFormField(
                  controller: _custoController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o custo do veículo';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saveVeiculo,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      textStyle: TextStyle(
                        fontSize: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Text('Cadastrar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
