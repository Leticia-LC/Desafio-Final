import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../Controller/Database.dart';
import '../Controller/Fipe_controller.dart';
import '../Model/Vehicle.dart';

class RegisterVehiclesScreen extends StatefulWidget {
  final Vehicle? vehicle;

  RegisterVehiclesScreen({this.vehicle});

  @override
  _RegisterVehiclesScreenState createState() => _RegisterVehiclesScreenState();
}
class _RegisterVehiclesScreenState extends State<RegisterVehiclesScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final FipeController _fipeController = FipeController();

  late TextEditingController _placaController;
  late TextEditingController _anoFabricacaoController;
  late TextEditingController _custoController;
  File? _image;

  var placaMaskFormatter = MaskTextInputFormatter(
    mask: 'AAA-####',
    filter: {"#": RegExp(r'[0-9]'), "A": RegExp(r'[A-Za-z]')},
    type: MaskAutoCompletionType.lazy,
  );

  List<VehicleBrand> _brands = [];
  List<VehicleModel> _models = [];
  VehicleBrand? _selectedBrand;
  VehicleModel? _selectedModel;

  @override
  /// // Inicializa os controladores com dados do veículo
  void initState() {
    super.initState();
    _placaController = TextEditingController(text: widget.vehicle?.plate ?? '');
    _anoFabricacaoController = TextEditingController(
        text: widget.vehicle?.yearOfManufacture.toString() ?? '');
    _custoController =
        TextEditingController(text: widget.vehicle?.cost.toString() ?? '');
    if (widget.vehicle != null &&
        widget.vehicle!.imagePath != null &&
        widget.vehicle!.imagePath!.isNotEmpty) {
      _image = File(widget.vehicle!.imagePath!);
      _loadBrandsAndModelsForEdit();
    } else {
      _loadBrands();
    }
  }

  @override
  void dispose() {
    _placaController.dispose();
    _anoFabricacaoController.dispose();
    _custoController.dispose();
    super.dispose();
  }
  /// Método para carregar marcas de veículos
  Future<void> _loadBrands() async {
    try {
      List<VehicleBrand> brands = await _fipeController.getBrands();
      setState(() {
        _brands = brands;
      });
    } catch (e) {
      setState(() {
        _brands = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar marcas: $e')),
      );
    }
  }
  /// Método para carregar marcas e modelos durante a edição
  Future<void> _loadBrandsAndModelsForEdit() async {
    try {
      List<VehicleBrand> brands = await _fipeController.getBrands();
      setState(() {
        _brands = brands;
        _selectedBrand =
            brands.firstWhere((brand) => brand.name == widget.vehicle!.brand);
      });
      if (_selectedBrand != null) {
        List<VehicleModel> models =
            await _fipeController.getModels(_selectedBrand!.code);
        setState(() {
          _models = models;
          _selectedModel = models
              .firstWhere((model) => model.name == widget.vehicle!.model);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar marcas e modelos: $e')),
      );
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
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _saveVehicle() async {
    if (_formKey.currentState!.validate()) {
      Vehicle vehicle = Vehicle(
        plate: _placaController.text,
        brand: _selectedBrand!.name,
        model: _selectedModel!.name,
        yearOfManufacture: int.parse(_anoFabricacaoController.text),
        cost: double.parse(_custoController.text),
        imagePath: _image?.path ?? '',
      );

      if (widget.vehicle == null) {
        await _dbHelper.saveVehicle(vehicle);
      } else {
        print(
            'Atualizando veículo: ${vehicle.plate}, ${vehicle.brand}, ${vehicle.model}, ${vehicle.yearOfManufacture}, ${vehicle.cost}');
        await _dbHelper.updateVehicle(vehicle);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veículo salvo com sucesso!')),
      );

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.vehicle == null ? 'Cadastro de Veículo' : 'Atualizar Veículo',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Placa',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              TextFormField(
                controller: _placaController,
                inputFormatters: [placaMaskFormatter],
                decoration: InputDecoration(
                  hintText: "Placa do veículo",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a placa do veículo';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Text(
                'Marca',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              DropdownButtonFormField<VehicleBrand>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                value: _selectedBrand,
                onChanged: (VehicleBrand? newValue) async {
                  setState(() {
                    _selectedBrand = newValue;
                    _selectedModel = null;
                    _models = [];
                  });
                  if (_selectedBrand != null) {
                    await _loadModels(_selectedBrand!.code);
                  }
                },
                items: _brands
                    .map<DropdownMenuItem<VehicleBrand>>((VehicleBrand brand) {
                  return DropdownMenuItem<VehicleBrand>(
                    value: brand,
                    child: Text(brand.name),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione a marca do veículo';
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
              DropdownButtonFormField<VehicleModel>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                value: _selectedModel,
                onChanged: (VehicleModel? newValue) {
                  setState(() {
                    _selectedModel = newValue;
                  });
                },
                items: _models
                    .map<DropdownMenuItem<VehicleModel>>((VehicleModel model) {
                  return DropdownMenuItem<VehicleModel>(
                    value: model,
                    child: Text(model.name),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione o modelo do veículo';
                  }
                  return null;
                },
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
                  hintText: "Ano de fabricação",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o ano de fabricação do veículo';
                  }
                  return null;
                },
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
                  hintText: "Custo do veículo",
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
              SizedBox(height: 10),
              Text(
                'Imagem',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              GestureDetector(
                onTap: _pickImage,
                child: _image == null
                    ? Container(
                        width: double.infinity,
                        height: 150,
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.add_a_photo,
                          color: Colors.grey[800],
                        ),
                      )
                    : Image.file(
                        _image!,
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveVehicle,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  child:
                      Text(widget.vehicle == null ? 'Cadastrar' : 'Atualizar'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
