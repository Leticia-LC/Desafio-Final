import 'package:flutter/material.dart';
import '../Model/Database.dart';
import '../Model/Cliente.dart';

class CadastroClientesScreen extends StatefulWidget {
  @override
  _CadastroClienteScreenState createState() => _CadastroClienteScreenState();
}

class _CadastroClienteScreenState extends State<CadastroClientesScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  late TextEditingController _clientNameController;
  late TextEditingController _phoneController;
  late TextEditingController _cnpjController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;

  @override
  void initState() {
    super.initState();
    _clientNameController = TextEditingController();
    _phoneController = TextEditingController();
    _cnpjController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
  }

  @override
  void dispose() {
    _clientNameController.dispose();
    _phoneController.dispose();
    _cnpjController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  void _saveCliente() async {
    if (_formKey.currentState!.validate()) {
      Cliente cliente = Cliente(
        clientName: _clientNameController.text,
        clientPhoneNumber: int.parse(_phoneController.text),
        cnpj: int.parse(_cnpjController.text),
        city: _cityController.text,
        clientState: _stateController.text,
      );

      await _dbHelper.saveCliente(cliente);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cliente cadastrado com sucesso!')),
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
        title: Text('Cadastro de Cliente'),
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
                  'Nome',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                TextFormField(
                  controller: _clientNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome do cliente';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Text(
                  'Telefone',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o telefone do cliente';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Text(
                  'CNPJ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                TextFormField(
                  controller: _cnpjController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o CNPJ do cliente';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Text(
                  'Cidade',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a cidade do cliente';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Text(
                  'Estado',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                TextFormField(
                  controller: _stateController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
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
                    onPressed: _saveCliente,
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