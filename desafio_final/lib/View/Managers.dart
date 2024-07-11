import 'package:flutter/material.dart';
import '../Controller/Database.dart';
import '../Model/Manager.dart';
import 'Register_managers.dart';

class ManagersScreen extends StatefulWidget {
  @override
  _ManagersScreenState createState() => _ManagersScreenState();
}

class _ManagersScreenState extends State<ManagersScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Manager>> _fetchManagers() async {
    return await _dbHelper.getManagers();
  }

  void _deleteManager(String cpf) async {
    await _dbHelper.deleteManager(cpf);
    setState(() {});
  }

  void _updateManager(Manager manager) async {
    bool? updatedManager = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RegisterManagersScreen(manager: manager)),
    );
    if (updatedManager == true) {
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
      body: FutureBuilder<List<Manager>>(
        future: _fetchManagers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar Gerentes'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum gerente cadastrado'));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final manager = snapshot.data![index];
                return GestureDetector(
                  onTap: () => _updateManager(manager),
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
                                'Nome: ${manager.managerName}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8.0),
                              Text('Telefone: ${manager.managerphoneNumber}'),
                              SizedBox(height: 8.0),
                              Text('CPF: ${manager.cpf}'),
                              SizedBox(height: 8.0),
                              Text('Estado: ${manager.managerState}'),
                              SizedBox(height: 8.0),
                              Text(
                                  'Percentual de comissão: ${manager.percentage}%'),
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
                                  title: Text('Deletar gerente?'),
                                  content: Text(
                                      'Tem certeza que deseja deletar o gerente ${manager.managerName}?'),
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
                                        _deleteManager(manager.cpf);
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
          bool? registeredManager = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterManagersScreen()),
          );
          if (registeredManager == true) {
            setState(() {});
          }
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
