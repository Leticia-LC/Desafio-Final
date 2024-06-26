import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../Controller/Cnpj_controller.dart';
import '../Controller/Cep_controller.dart';
import '../Model/Database.dart';
import '../Model/Cliente.dart';

class CadastroClientesScreen extends StatefulWidget {
  final Cliente? cliente;

  CadastroClientesScreen({Key? key, this.cliente}) : super(key: key);

  @override
  _CadastroClientesScreenState createState() => _CadastroClientesScreenState();
}

class _CadastroClientesScreenState extends State<CadastroClientesScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final CnpjController _cnpjController = CnpjController();
  final CepController _cepController = CepController();

  late TextEditingController _clientNameController;
  late TextEditingController _phoneController;
  late TextEditingController _cnpjControllerText;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _cepControllerText;

  @override
  void initState() {
    super.initState();
    _clientNameController = TextEditingController();
    _phoneController = TextEditingController();
    _cnpjControllerText = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _cepControllerText = TextEditingController();

    if (widget.cliente != null) {
      _clientNameController.text = widget.cliente!.clientName;
      _phoneController.text = widget.cliente!.clientPhoneNumber.toString();
      _cnpjControllerText.text = widget.cliente!.cnpj;
      _cityController.text = widget.cliente!.city;
      _stateController.text = widget.cliente!.clientState;
      _cepControllerText.text = widget.cliente!.cep;
    }
  }

  @override
  void dispose() {
    _clientNameController.dispose();
    _phoneController.dispose();
    _cnpjControllerText.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _cepControllerText.dispose();
    super.dispose();
  }

  void _validateAndSave() async {
    final cnpj = _cnpjControllerText.text.replaceAll(RegExp(r'[^\d]'), '');
    final cep = _cepControllerText.text.replaceAll(RegExp(r'[^\d]'), '');

    if (_formKey.currentState!.validate()) {
      await _validateCepAndFillFields(cep);

      if (_cepController.isCepValid) {
        await _cnpjController.validateCnpjAndState(cnpj, _stateController.text);
        if (_cnpjController.isCnpjValid) {
          _saveCliente();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_cnpjController.message)));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_cepController.message)));
      }
    }
  }

  Future<void> _validateCepAndFillFields(String cep) async {
    await _cepController.validateCep(cep);
    if (_cepController.isCepValid) {
      setState(() {
        _cityController.text = _cepController.cepData!['city'];
        _stateController.text = _cepController.cepData!['state'];
      });
    }
  }

  void _saveCliente() async {
    final number = _phoneController.text.replaceAll(RegExp(r'[^\d]'), '');

    Cliente cliente = Cliente(
      clientName: _clientNameController.text,
      clientPhoneNumber: int.parse(number),
      cnpj: _cnpjControllerText.text,
      city: _cityController.text,
      clientState: _stateController.text,
      cep: _cepControllerText.text,
    );

    if (widget.cliente == null) {
      await _dbHelper.saveCliente(cliente);
    } else {
      cliente.cnpj = widget.cliente!.cnpj;
      await _dbHelper.updateCliente(cliente);
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cliente salvo com sucesso!')));

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.cliente == null ? 'Cadastro de Cliente' : 'Atualizar Cliente'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nome', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              TextFormField(
                controller: _clientNameController,
                decoration: InputDecoration(hintText: "Nome do cliente", border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do cliente';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Text('Telefone', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(hintText: "(00) 00000-0000", border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o telefone do cliente';
                  }
                  return null;
                },
                inputFormatters: [MaskTextInputFormatter(mask: '(##) #####-####')],
              ),
              SizedBox(height: 10),
              Text('CNPJ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              TextFormField(
                controller: _cnpjControllerText,
                decoration: InputDecoration(hintText: "00.000.000/0001-00", border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o CNPJ do cliente';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Text('CEP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              TextFormField(
                controller: _cepControllerText,
                decoration: InputDecoration(hintText: "00000-000", border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o CEP do cliente';
                  }
                  return null;
                },
                inputFormatters: [MaskTextInputFormatter(mask: '#####-###')],
                onChanged: (value) {
                  if (value.length == 9) {
                    _validateCepAndFillFields(value.replaceAll(RegExp(r'[^\d]'), ''));
                  }
                },
              ),
              SizedBox(height: 10),
              Text('Cidade', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              TextFormField(
                controller: _cityController,
                readOnly: true,
                decoration: InputDecoration(hintText: "Cidade", border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a cidade do cliente';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Text('Estado', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              TextFormField(
                controller: _stateController,
                readOnly: true,
                decoration: InputDecoration(hintText: "Estado", border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o estado do cliente';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _validateAndSave,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  child: Text(widget.cliente == null ? 'Cadastrar' : 'Atualizar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
