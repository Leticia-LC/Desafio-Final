import 'package:flutter/material.dart';
import '../Model/Database.dart';
import '../Model/Gerente.dart';

class CadastroGerentesScreen extends StatefulWidget {
  final Gerente? gerente;

  CadastroGerentesScreen({this.gerente});

  @override
  _CadastroGerenteScreenState createState() => _CadastroGerenteScreenState();
}

class _CadastroGerenteScreenState extends State<CadastroGerentesScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  late TextEditingController _managerNameController;
  late TextEditingController _cpfController;
  late TextEditingController _managerStateController;
  late TextEditingController _managerPhoneNumberController;
  late TextEditingController _percentageController;

  final List<String> estados = [
    'AC',
    'AL',
    'AP',
    'AM',
    'BA',
    'CE',
    'DF',
    'ES',
    'GO',
    'MA',
    'MT',
    'MS',
    'MG',
    'PA',
    'PB',
    'PR',
    'PE',
    'PI',
    'RJ',
    'RN',
    'RS',
    'RO',
    'RR',
    'SC',
    'SP',
    'SE',
    'TO'
  ];

  @override
  void initState() {
    super.initState();
    _managerNameController =
        TextEditingController(text: widget.gerente?.managerName ?? '');
    _cpfController = TextEditingController(text: widget.gerente?.cpf ?? '');
    _managerStateController =
        TextEditingController(text: widget.gerente?.managerState ?? '');
    _managerPhoneNumberController =
        TextEditingController(text: widget.gerente?.managerphoneNumber ?? '');
    _percentageController = TextEditingController(
        text: widget.gerente != null
            ? widget.gerente!.percentage.toString()
            : '');
  }

  @override
  void dispose() {
    _managerNameController.dispose();
    _cpfController.dispose();
    _managerStateController.dispose();
    _managerPhoneNumberController.dispose();
    _percentageController.dispose();
    super.dispose();
  }

  void _saveGerente() async {
    if (_formKey.currentState!.validate()) {
      Gerente gerente = Gerente(
        managerName: _managerNameController.text,
        cpf: _cpfController.text,
        managerState: _managerStateController.text,
        managerphoneNumber: _managerPhoneNumberController.text,
        percentage: int.parse(_percentageController.text),
      );

      if (widget.gerente == null) {
        await _dbHelper.saveGerente(gerente);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gerente cadastrado com sucesso!')),
        );
      } else {
        await _dbHelper.updateGerente(gerente);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gerente atualizado com sucesso!')),
        );
      }

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.gerente == null
            ? 'Cadastro de Gerente'
            : 'Atualizar Gerente'),
      ),
      body: SingleChildScrollView(
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
                controller: _managerNameController,
                decoration: InputDecoration(
                  hintText: "Nome do gerente",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do gerente';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Text(
                'CPF',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              TextFormField(
                controller: _cpfController,
                decoration: InputDecoration(
                  hintText: "000.000.000-00",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o CPF do gerente';
                  }
                  final cpfRegex = RegExp(r'^[0-9]{11}$');
                  if (!cpfRegex.hasMatch(value)) {
                    return 'CPF inválido';
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
              DropdownButtonFormField<String>(
                value: _managerStateController.text.isNotEmpty
                    ? _managerStateController.text
                    : null,
                items: estados.map((String estado) {
                  return DropdownMenuItem<String>(
                    value: estado,
                    child: Text(estado),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _managerStateController.text = newValue!;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione o estado do gerente';
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
                controller: _managerPhoneNumberController,
                decoration: InputDecoration(
                  hintText: "(00) 00000-0000",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o telefone do gerente';
                  }
                  final phoneRegex = RegExp(r'^[0-9]{11}$');
                  if (!phoneRegex.hasMatch(value)) {
                    return 'Telefone inválido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Text(
                'Percentual de Comissão',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              TextFormField(
                controller: _percentageController,
                decoration: InputDecoration(
                  hintText: "Percentual de comissão",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o percentual de comissão do gerente';
                  }
                  final percentage = int.tryParse(value);
                  if (percentage == null ||
                      percentage < 0 ||
                      percentage > 100) {
                    return 'Percentual de comissão inválido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveGerente,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  child:
                      Text(widget.gerente == null ? 'Cadastrar' : 'Atualizar'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
