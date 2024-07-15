import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../Controller/Cep_controller.dart';
import '../Controller/Cnpj_controller.dart';
import '../Controller/Database.dart';
import '../Model/Client.dart';

class RegisterClientsScreen extends StatefulWidget {
  final Client? client;

  RegisterClientsScreen({Key? key, this.client}) : super(key: key);

  @override
  _RegisterClientsScreenState createState() => _RegisterClientsScreenState();
}

class _RegisterClientsScreenState extends State<RegisterClientsScreen> {
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
  ///Inicializa os controllers de texto e preenche os campos com os dados do
  ///cliente, se um cliente já existir
  void initState() {
    super.initState();
    _clientNameController = TextEditingController();
    _phoneController = TextEditingController();
    _cnpjControllerText = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _cepControllerText = TextEditingController();

    if (widget.client != null) {
      _clientNameController.text = widget.client!.clientName;
      _phoneController.text = widget.client!.clientPhoneNumber.toString();
      _cnpjControllerText.text = widget.client!.cnpj;
      _cityController.text = widget.client!.city;
      _stateController.text = widget.client!.clientState;
      _cepControllerText.text = widget.client!.cep;
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
  /// Valida o formulário, verifica o CEP e CNPJ, e salva o cliente no banco
  /// de dados
  void _validateAndSave() async {
    final cnpj = _cnpjControllerText.text.replaceAll(RegExp(r'[^\d]'), '');
    final cep = _cepControllerText.text.replaceAll(RegExp(r'[^\d]'), '');

    if (_formKey.currentState!.validate()) {
      await _validateCepAndFillFields(cep);

      if (_cepController.isCepValid) {
        await _cnpjController.validateCnpjAndState(cnpj, _stateController.text);
        if (_cnpjController.isCnpjValid) {
          _saveClient();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(_cnpjController.message)));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(_cepController.message)));
      }
    }
  }
  /// Valida o CEP e preenche automaticamente os campos de cidade e estado
  Future<void> _validateCepAndFillFields(String cep) async {
    await _cepController.validateCep(cep);
    if (_cepController.isCepValid) {
      setState(() {
        _cityController.text = _cepController.cepData!['city'];
        _stateController.text = _cepController.cepData!['state'];
      });
    }
  }
  /// Salva ou atualiza as informações do cliente no banco de dados
  void _saveClient() async {
    final number = _phoneController.text.replaceAll(RegExp(r'[^\d]'), '');

    Client client = Client(
      clientName: _clientNameController.text,
      clientPhoneNumber: int.parse(number),
      cnpj: _cnpjControllerText.text,
      city: _cityController.text,
      clientState: _stateController.text,
      cep: _cepControllerText.text,
    );

    if (widget.client == null) {
      await _dbHelper.saveClient(client);
    } else {
      client.cnpj = widget.client!.cnpj;
      await _dbHelper.updateClient(client);
    }

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cliente salvo com sucesso!')));

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.client == null
            ? 'Cadastro de Cliente'
            : 'Atualizar Cliente'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nome',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              TextFormField(
                controller: _clientNameController,
                decoration: InputDecoration(
                    hintText: "Nome do cliente", border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do cliente';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Text('Telefone',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                    hintText: "(00) 00000-0000", border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o telefone do cliente';
                  }
                  return null;
                },
                inputFormatters: [
                  MaskTextInputFormatter(mask: '(##) #####-####')
                ],
              ),
              SizedBox(height: 10),
              Text('CNPJ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              TextFormField(
                controller: _cnpjControllerText,
                decoration: InputDecoration(
                    hintText: "00.000.000/0001-00",
                    border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o CNPJ do cliente';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Text('CEP',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              TextFormField(
                controller: _cepControllerText,
                decoration: InputDecoration(
                    hintText: "00000-000", border: OutlineInputBorder()),
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
                    _validateCepAndFillFields(
                        value.replaceAll(RegExp(r'[^\d]'), ''));
                  }
                },
              ),
              SizedBox(height: 10),
              Text('Cidade',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              TextFormField(
                controller: _cityController,
                readOnly: true,
                decoration: InputDecoration(
                    hintText: "Cidade", border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a cidade do cliente';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Text('Estado',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              TextFormField(
                controller: _stateController,
                readOnly: true,
                decoration: InputDecoration(
                    hintText: "Estado", border: OutlineInputBorder()),
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
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  child:
                      Text(widget.client == null ? 'Cadastrar' : 'Atualizar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
