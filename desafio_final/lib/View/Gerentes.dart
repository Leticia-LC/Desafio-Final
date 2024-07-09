import 'package:flutter/material.dart';
import '../Controller/Database.dart';
import '../Model/Gerente.dart';
import 'Cadastro_gerentes.dart';

class GerentesScreen extends StatefulWidget {
  @override
  _GerentesScreenState createState() => _GerentesScreenState();
}

class _GerentesScreenState extends State<GerentesScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Gerente>> _fetchGerentes() async {
    return await _dbHelper.getGerentes();
  }

  void _navigateToCadastroGerentesScreen(
      BuildContext context, Gerente? gerente) async {
    bool? gerenteAtualizado = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CadastroGerentesScreen(gerente: gerente)),
    );
    if (gerenteAtualizado == true) {
      setState(() {});
    }
  }

  void _deleteGerente(String cpf) async {
    await _dbHelper.deleteGerente(cpf);
    setState(() {});
  }

  void _updateGerente(Gerente gerente) async {
    bool? gerenteAtualizado = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CadastroGerentesScreen(gerente: gerente)),
    );
    if (gerenteAtualizado == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Gerentes', style: TextStyle(color: Colors.black)),
      ),
      body: FutureBuilder<List<Gerente>>(
        future: _fetchGerentes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar os gerentes'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum gerente cadastrado'));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final gerente = snapshot.data![index];
                return GestureDetector(
                  onTap: () => _updateGerente(gerente),
                  // Chama o método de atualização ao clicar
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nome: ${gerente.managerName}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8.0),
                              Text('Telefone: ${gerente.managerphoneNumber}'),
                              SizedBox(height: 8.0),
                              Text('CPF: ${gerente.cpf}'),
                              SizedBox(height: 8.0),
                              Text('Estado: ${gerente.managerState}'),
                              SizedBox(height: 8.0),
                              Text(
                                  'Percentual de Comissão: ${gerente.percentage}%'),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Deseja deletar gerente?'),
                                  content: Text(
                                      'Tem certeza que deseja deletar o gerente ${gerente.managerName}?'),
                                  actions: [
                                    TextButton(
                                      child: Text('Não'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Sim'),
                                      onPressed: () {
                                        _deleteGerente(gerente.cpf);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? gerenteCadastrado = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CadastroGerentesScreen()),
          );
          if (gerenteCadastrado == true) {
            setState(() {});
          }
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
