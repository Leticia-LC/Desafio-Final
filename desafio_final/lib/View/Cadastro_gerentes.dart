import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
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

  @override
  void initState() {
    super.initState();
    _managerNameController = TextEditingController(text: widget.gerente?.managerName ?? '');
    _cpfController = TextEditingController(text: widget.gerente?.cpf ?? '');
    _managerStateController = TextEditingController(text: widget.gerente?.managerState ?? '');
    _managerPhoneNumberController = TextEditingController(text: widget.gerente?.managerphoneNumber ?? '');
    _percentageController = TextEditingController(text: widget.gerente != null ? widget.gerente!.percentage.toString() : '');
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
      final cpf = _cpfController.text
          .replaceAll('.', '')
          .replaceAll('-', '');

      Gerente gerente = Gerente(
        managerName: _managerNameController.text,
        cpf: cpf,
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
        title: Text(widget.gerente == null ? 'Cadastro de Gerente' : 'Atualizar Gerente'),
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
                  controller: _managerNameController,
                  decoration: InputDecoration(
                    hintText: "nome",
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
                    return null;
                  },
                  inputFormatters: [
                    MaskTextInputFormatter(mask: '###.###.###-##'),
                  ],
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
                  controller: _managerStateController,
                  decoration: InputDecoration(
                    hintText: "estado",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o estado do gerente';
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
                    hintText: "telefone",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o telefone do gerente';
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
                    hintText: "percentual de comissão",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o percentual de comissão do gerente';
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
                      foregroundColor: Colors.white, backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    ),
                    child: Text(widget.gerente == null ? 'Cadastrar' : 'Atualizar'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
