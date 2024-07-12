import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../Controller/Database.dart';
import '../Model/Rent.dart';
import '../Model/Client.dart';
import '../Model/Manager.dart';
import '../Model/Vehicle.dart';

class RentalRegistrationScreen extends StatefulWidget {
  final Rent? rent;

  RentalRegistrationScreen({this.rent});

  @override
  _RentalRegistrationScreenState createState() =>
      _RentalRegistrationScreenState();
}

class _RentalRegistrationScreenState extends State<RentalRegistrationScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();
  DateTime? _startDate;
  DateTime? _endDate;
  Client? _selectedClient;
  Vehicle? _selectedVehicle;
  List<Client> _clients = [];
  List<Vehicle> _vehicles = [];

  @override
  void initState() {
    super.initState();
    _loadClients();
    _loadVehicles();
  }

  Future<void> _loadClients() async {
    var clients = await _dbHelper.getClients();
    setState(() {
      _clients = clients;
    });
  }

  Future<void> _loadVehicles() async {
    var vehicles = await _dbHelper.getVehicles();
    setState(() {
      _vehicles = vehicles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
            widget.rent == null ? 'Cadastro de Aluguel' : 'Atualizar Aluguel'),
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
              DropdownButtonFormField<Client>(
                value: _selectedClient,
                hint: Text('Selecione o Cliente'),
                onChanged: (Client? client) {
                  setState(() {
                    _selectedClient = client;
                  });
                },
                items: _clients.map((Client client) {
                  return DropdownMenuItem<Client>(
                    value: client,
                    child: Text(client.clientName),
                  );
                }).toList(),
                validator: (value) =>
                value == null ? 'Selecione um cliente' : null,
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
              DropdownButtonFormField<Vehicle>(
                value: _selectedVehicle,
                hint: Text('Selecione o Veículo'),
                onChanged: (Vehicle? vehicle) {
                  setState(() {
                    _selectedVehicle = vehicle;
                  });
                },
                items: _vehicles.map((Vehicle vehicle) {
                  return DropdownMenuItem<Vehicle>(
                    value: vehicle,
                    child: Text('${vehicle.brand} ${vehicle.model}'),
                  );
                }).toList(),
                validator: (value) =>
                value == null ? 'Selecione um veículo' : null,
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
                  _startDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  setState(() {});
                },
                validator: (value) =>
                _startDate == null ? 'Selecione a data de início' : null,
                readOnly: true,
                controller: TextEditingController(
                  text: _startDate != null
                      ? DateFormat('dd/MM/yyyy').format(_startDate!)
                      : '',
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
                  _endDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  setState(() {});
                },
                validator: (value) =>
                _endDate == null ? 'Selecione a data de término' : null,
                readOnly: true,
                controller: TextEditingController(
                  text: _endDate != null
                      ? DateFormat('dd/MM/yyyy').format(_endDate!)
                      : '',
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      int numberOfDays =
                          _endDate!.difference(_startDate!).inDays;
                      double totalValue = numberOfDays * _selectedVehicle!.cost;

                      Manager? manager = await _dbHelper
                          .getManagerByState(_selectedClient!.clientState);

                      Rent rent = Rent(
                        client: _selectedClient!.cnpj,
                        startDate: _startDate!.millisecondsSinceEpoch,
                        endDate: _endDate!.millisecondsSinceEpoch,
                        numberOfDays: numberOfDays,
                        totalValue: totalValue,
                        vehiclePlate: _selectedVehicle!.plate,
                      );

                      if (widget.rent != null) {
                        rent.idRent = widget.rent!.idRent;
                        await _dbHelper.updateRent(rent);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Aluguel atualizado com sucesso!')),
                        );
                      } else {
                        await _dbHelper.saveRent(rent);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Aluguel cadastrado com sucesso!')),
                        );
                      }

                      Navigator.pop(context, true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  child: Text(widget.rent == null ? 'Cadastrar' : 'Atualizar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
