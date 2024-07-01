import 'package:flutter/material.dart';
import '../Model/Cliente.dart';
import '../Model/Database.dart';
import '../Model/Gerente.dart';
import 'Cadastro_clientes.dart';

class ClientesScreen extends StatefulWidget {
  @override
  _ClientesScreenState createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Cliente>> _fetchClientes() async {
    try {
      List<Cliente> clientes = await _dbHelper.getClientes();
      print('Clientes carregados: ${clientes.length}');
      return clientes;
    } catch (e) {
      print('Erro ao buscar clientes: $e');
      return [];
    }
  }

  void _deleteCliente(String cnpj) async {
    try {
      await _dbHelper.deleteCliente(cnpj);
      setState(() {});
    } catch (e) {
      print('Erro ao deletar cliente: $e');
    }
  }

  void _navigateToCadastroClientesScreen(
      BuildContext context, Cliente cliente) async {
    bool? clienteAtualizado = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CadastroClientesScreen(cliente: cliente)),
    );
    if (clienteAtualizado == true) {
      setState(() {});
    }
  }

  void _navigateToNovoCadastroClientesScreen(BuildContext context) async {
    bool? clienteCadastrado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CadastroClientesScreen()),
    );
    if (clienteCadastrado == true) {
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
        title: Text('Clientes', style: TextStyle(color: Colors.black)),
      ),
      body: FutureBuilder<List<Cliente>>(
        future: _fetchClientes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Erro no snapshot: ${snapshot.error}');
            return Center(child: Text('Erro ao carregar os clientes'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            print('Nenhum cliente cadastrado');
            return Center(child: Text('Nenhum cliente cadastrado'));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final cliente = snapshot.data![index];
                return FutureBuilder<Gerente?>(
                  future: _dbHelper.getGerenteByState(cliente.clientState),
                  builder: (context, gerenteSnapshot) {
                    if (gerenteSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (gerenteSnapshot.hasError) {
                      return Text('Erro ao carregar o gerente');
                    } else {
                      final gerente = gerenteSnapshot.data;
                      return GestureDetector(
                        onTap: () {
                          _navigateToCadastroClientesScreen(context, cliente);
                        },
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
                                      'Nome: ${cliente.clientName}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                        'Telefone: ${cliente.clientPhoneNumber}'),
                                    SizedBox(height: 8.0),
                                    Text('CNPJ: ${cliente.cnpj}'),
                                    SizedBox(height: 8.0),
                                    Text('Cidade: ${cliente.city}'),
                                    SizedBox(height: 8.0),
                                    Text('Estado: ${cliente.clientState}'),
                                    SizedBox(height: 8.0),
                                    Text(
                                        'Gerente Responsável: ${gerente?.managerName ?? 'N/A'}'),
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
                                        title: Text('Deseja deletar cliente?'),
                                        content: Text(
                                            'Tem certeza que deseja deletar o cliente ${cliente.clientName}?'),
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
                                              _deleteCliente(cliente.cnpj);
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
                    }
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _navigateToNovoCadastroClientesScreen(context);
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
