import 'package:flutter/material.dart';
import '../Controller/Database.dart';
import '../Model/Client.dart';
import '../Model/Manager.dart';
import 'Register_clients.dart';

class ClientsScreen extends StatefulWidget {
  @override
  _ClientsScreenState createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Client>> _fetchClients() async {
    try {
      List<Client> clients = await _dbHelper.getClients();
      print('Clientes carregados: ${clients.length}');
      return clients;
    } catch (e) {
      print('Error ao carregar clientes: $e');
      return [];
    }
  }

  void _deleteClient(String cnpj) async {
    try {
      await _dbHelper.deleteClient(cnpj);
      setState(() {});
    } catch (e) {
      print('Erro ao deletetar cliente: $e');
    }
  }

  void _navigateToRegisterClientsScreen(BuildContext context, Client client) async {
    bool? updatedClient = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterClientsScreen(client: client)),
    );
    if (updatedClient == true) {
      setState(() {});
    }
  }

  void _navigateToNewRegisterClientsScreen(BuildContext context) async {
    bool? registeredClient = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterClientsScreen()),
    );
    if (registeredClient == true) {
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
      body: FutureBuilder<List<Client>>(
        future: _fetchClients(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Erro no snapshot: ${snapshot.error}');
            return Center(child: Text('Error ao carregar clientes'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            print('Nenhum cliente registrado');
            return Center(child: Text('Nenhum cliente registrado'));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final client = snapshot.data![index];
                return FutureBuilder<Manager?>(
                  future: _dbHelper.getManagerByState(client.clientState),
                  builder: (context, managerSnapshot) {
                    if (managerSnapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (managerSnapshot.hasError) {
                      return Text('Erro ao carregar gerente');
                    } else {
                      final manager = managerSnapshot.data;
                      return GestureDetector(
                        onTap: () {
                          _navigateToRegisterClientsScreen(context, client);
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
                                      'Cliente: ${client.clientName}',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text('Telefone: ${client.clientPhoneNumber}'),
                                    SizedBox(height: 8.0),
                                    Text('CNPJ: ${client.cnpj}'),
                                    SizedBox(height: 8.0),
                                    Text('Cidade: ${client.city}'),
                                    SizedBox(height: 8.0),
                                    Text('Estado: ${client.clientState}'),
                                    SizedBox(height: 8.0),
                                    Text('Gerente Responsável: ${manager?.managerName ?? 'N/A'}'),
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
                                        title: Text('Deletar cliente?'),
                                        content: Text('Tem certeza que deseja deletar o cliente ${client.clientName}?'),
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
                                              _deleteClient(client.cnpj);
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
          _navigateToNewRegisterClientsScreen(context);
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
