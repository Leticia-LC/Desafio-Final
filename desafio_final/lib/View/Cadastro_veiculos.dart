import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../Controller/Fipe_controller.dart';
import '../Model/Database.dart';
import '../Model/Veiculo.dart';

class CadastroVeiculosScreen extends StatefulWidget {
  @override
  _CadastroVeiculosScreenState createState() => _CadastroVeiculosScreenState();
}

class _CadastroVeiculosScreenState extends State<CadastroVeiculosScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final FipeController _fipeController = FipeController();

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

  List<VehicleBrand> _brands = [];
  List<VehicleModel> _models = [];
  VehicleBrand? _selectedBrand;
  VehicleModel? _selectedModel;

  @override
  void initState() {
    super.initState();
    _placaController = TextEditingController();
    _anoFabricacaoController = TextEditingController();
    _custoController = TextEditingController();
    _loadBrands();
  }

  @override
  void dispose() {
    _placaController.dispose();
    _anoFabricacaoController.dispose();
    _custoController.dispose();
    super.dispose();
  }

  Future<void> _loadBrands() async {
    try {
      List<VehicleBrand> brands = await _fipeController.getBrands();
      setState(() {
        _brands = brands;
      });
      print('Marcas carregadas: $_brands');
    } catch (e) {
      setState(() {
        _brands = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar marcas: $e')),
      );
      print('Erro ao carregar marcas: $e');
    }
  }

  Future<void> _loadModels(String brandCode) async {
    try {
      List<VehicleModel> models = await _fipeController.getModels(brandCode);
      setState(() {
        _models = models;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar modelos: $e')),
      );
    }
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
        marca: _selectedBrand?.name ?? '',
        modelo: _selectedModel?.name ?? '',
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
        SnackBar(content: Text('Por favor, preencha todos os campos e selecione uma imagem!')),
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
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<VehicleBrand>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Marca',
                        ),
                        value: _selectedBrand,
                        items: _brands.map((brand) {
                          return DropdownMenuItem<VehicleBrand>(
                            value: brand,
                            child: Text(brand.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedBrand = value;
                            _selectedModel = null;
                            _models = [];
                            if (_selectedBrand != null) {
                              _loadModels(_selectedBrand!.code);
                            }
                          });
                        },
                        validator: (value) => value == null ? 'Por favor, selecione uma marca' : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<VehicleModel>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Modelo',
                        ),
                        value: _selectedModel,
                        items: _models.map((model) {
                          return DropdownMenuItem<VehicleModel>(
                            value: model,
                            child: Text(model.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedModel = value;
                          });
                        },
                        validator: (value) => value == null ? 'Por favor, selecione um modelo' : null,
                      ),
                    ),
                  ],
                ),
                _buildTextField('Placa', _placaController, isMasked: true, maskFormatter: placaMaskFormatter),
                _buildTextField('Ano de Fabricação', _anoFabricacaoController,
                    isNumeric: true, isMasked: true, maskFormatter: MaskTextInputFormatter(mask: '####')),
                _buildTextField('Custo', _custoController, isNumeric: true),
                SizedBox(height: 20),
                Text(
                  'Imagem do veículo:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(height: 8.0),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    color: Colors.grey[200],
                    height: 150,
                    width: double.infinity,
                    child: _image == null
                        ? Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
                        : Image.file(_image!, fit: BoxFit.cover),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saveVeiculo,
                    child: Text('Salvar Veículo'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    ),
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
