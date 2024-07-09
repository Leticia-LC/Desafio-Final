import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Controller/Database.dart';
import '../Model/Aluguel.dart';
import '../Model/Cliente.dart';
import '../Model/Gerente.dart';
import '../Model/Veiculo.dart';

class CadastroAluguelScreen extends StatefulWidget {
  final Aluguel? aluguel;

  CadastroAluguelScreen({this.aluguel});

  @override
  _CadastroAluguelScreenState createState() => _CadastroAluguelScreenState();
}

class _CadastroAluguelScreenState extends State<CadastroAluguelScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();
  DateTime? _dataInicio;
  DateTime? _dataTermino;
  Cliente? _clienteSelecionado;
  Veiculo? _veiculoSelecionado;
  List<Cliente> _clientes = [];
  List<Veiculo> _veiculos = [];

  @override
  void initState() {
    super.initState();
    _loadClientes();
    _loadVeiculos();
  }

  Future<void> _loadClientes() async {
    var clientes = await _dbHelper.getClientes();
    setState(() {
      _clientes = clientes;
    });
  }

  Future<void> _loadVeiculos() async {
    var veiculos = await _dbHelper.getVeiculos();
    setState(() {
      _veiculos = veiculos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.aluguel == null ? 'Cadastro de Aluguel' : 'Atualizar Aluguel'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cliente',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              DropdownButtonFormField<Cliente>(
                value: _clienteSelecionado,
                hint: Text('Selecione o Cliente'),
                onChanged: (Cliente? cliente) {
                  setState(() {
                    _clienteSelecionado = cliente;
                  });
                },
                items: _clientes.map((Cliente cliente) {
                  return DropdownMenuItem<Cliente>(
                    value: cliente,
                    child: Text(cliente.clientName),
                  );
                }).toList(),
                validator: (value) => value == null ? 'Selecione um cliente' : null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Veículo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              DropdownButtonFormField<Veiculo>(
                value: _veiculoSelecionado,
                hint: Text('Selecione o Veículo'),
                onChanged: (Veiculo? veiculo) {
                  setState(() {
                    _veiculoSelecionado = veiculo;
                  });
                },
                items: _veiculos.map((Veiculo veiculo) {
                  return DropdownMenuItem<Veiculo>(
                    value: veiculo,
                    child: Text('${veiculo.marca} ${veiculo.modelo}'),
                  );
                }).toList(),
                validator: (value) => value == null ? 'Selecione um veículo' : null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Data de Início',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Selecione a data de início',
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  _dataInicio = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  setState(() {});
                },
                validator: (value) => _dataInicio == null ? 'Selecione a data de início' : null,
                readOnly: true,
                controller: TextEditingController(
                  text: _dataInicio != null ? DateFormat('dd/MM/yyyy').format(_dataInicio!) : '',
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Data de Término',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Selecione a data de término',
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  _dataTermino = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  setState(() {});
                },
                validator: (value) => _dataTermino == null ? 'Selecione a data de término' : null,
                readOnly: true,
                controller: TextEditingController(
                  text: _dataTermino != null ? DateFormat('dd/MM/yyyy').format(_dataTermino!) : '',
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      int numeroDias = _dataTermino!.difference(_dataInicio!).inDays;
                      double valorTotal = numeroDias * _veiculoSelecionado!.custo;

                      Gerente? gerente = await _dbHelper.getGerenteByState(_clienteSelecionado!.clientState);
                      double comissao = valorTotal * (gerente!.percentage / 100);

                      Aluguel aluguel = Aluguel(
                        cliente: _clienteSelecionado!.cnpj,
                        dataInicio: _dataInicio!.millisecondsSinceEpoch,
                        dataTermino: _dataTermino!.millisecondsSinceEpoch,
                        numeroDias: numeroDias,
                        valorTotal: valorTotal,
                      );

                      if (widget.aluguel != null) {
                        aluguel.id = widget.aluguel!.id;
                        await _dbHelper.updateAluguel(aluguel);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Aluguel atualizado com sucesso!')),
                        );
                      } else {
                        await _dbHelper.saveAluguel(aluguel);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Aluguel cadastrado com sucesso!')),
                        );
                      }

                      await _generatePDF(aluguel, _clienteSelecionado!, _veiculoSelecionado!, gerente, comissao);

                      Navigator.pop(context, true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  child: Text(widget.aluguel == null ? 'Cadastrar' : 'Atualizar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _generatePDF(Aluguel aluguel, Cliente cliente, Veiculo veiculo, Gerente gerente, double comissao) async {

  }
}
