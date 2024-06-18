import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
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
  File? _image;

  var placaMaskFormatter = MaskTextInputFormatter(
    mask: 'AAA-####',
    filter: {
      "#": RegExp(r'[0-9]'),
      "A": RegExp(r'[A-Za-z]')
    },
    type: MaskAutoCompletionType.lazy,
  );

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

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  void _saveVeiculo() async {
    if (_formKey.currentState!.validate() && _image != null) {
      Veiculo veiculo = Veiculo(
        marca: _marcaController.text,
        modelo: _modeloController.text,
        placa: _placaController.text,
        anoFabricacao: int.parse(_anoFabricacaoController.text),
        custo: int.parse(_custoController.text),
        imagemPath: _image!.path,
      );

      await _dbHelper.saveVeiculo(veiculo);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veículo cadastrado com sucesso!')),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos!')),
      );
    }
  }


  Widget _buildTextField(String label, TextEditingController controller,
      {String? hintText, bool isNumeric = false, bool isMasked = false, MaskTextInputFormatter? maskFormatter}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          SizedBox(height: 8.0),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(),
            ),
            keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira $label';
              }
              return null;
            },
            inputFormatters: isMasked ? [maskFormatter!] : [],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Cadastro de Veículo', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField('Marca', _marcaController),
                _buildTextField('Modelo', _modeloController),
                _buildTextField('Placa', _placaController,
                    isMasked: true, maskFormatter: placaMaskFormatter),
                _buildTextField('Ano de Fabricação', _anoFabricacaoController,
                    isNumeric: true, isMasked: true, maskFormatter: MaskTextInputFormatter(mask: '####')),
                _buildTextField('Custo', _custoController, isNumeric: true),
                SizedBox(height: 20),
                Text(
                  'Imagem do Veículo',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickImage,
                  child: _image != null
                      ? Image.file(
                    _image!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.add_a_photo,
                      color: Colors.grey[800],
                    ),
                  ),
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
