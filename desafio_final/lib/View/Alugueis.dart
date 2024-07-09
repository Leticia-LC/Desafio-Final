import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Controller/Database.dart';
import '../Model/Aluguel.dart';
import 'Cadastro_Alugueis.dart';


class AlugueisScreen extends StatefulWidget {
  @override
  _AlugueisScreenState createState() => _AlugueisScreenState();
}

class _AlugueisScreenState extends State<AlugueisScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Aluguel> _aluguels = [];

  @override
  void initState() {
    super.initState();
    _loadAluguels();
  }

  Future<void> _loadAluguels() async {
    var alugueis = await _dbHelper.getAlugueis();
    setState(() {
      _aluguels = alugueis;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Aluguéis'),
      ),
      body: _aluguels.isEmpty
          ? Center(child: Text('Nenhum aluguel registrado.'))
          : ListView.builder(
        itemCount: _aluguels.length,
        itemBuilder: (context, index) {
          Aluguel aluguel = _aluguels[index];
          return ListTile(
            title: Text('Cliente: ${aluguel.cliente}'),
            subtitle: Text('De: ${DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(aluguel.dataInicio))} '
                'Até: ${DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(aluguel.dataTermino))}'),
            trailing: Text('R\$ ${aluguel.valorTotal.toStringAsFixed(2)}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? aluguelCadastrado = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CadastroAluguelScreen()),
          );
          if (aluguelCadastrado == true) {
            _loadAluguels();
          }
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AlugueisScreen(),
  ));
}
