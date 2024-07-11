import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Controller/Database.dart';
import '../Model/Rent.dart';
import 'Register_rentals.dart';

class RentalsScreen extends StatefulWidget {
  @override
  _RentalsScreenState createState() => _RentalsScreenState();
}

class _RentalsScreenState extends State<RentalsScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Rent> _rentals = [];

  @override
  void initState() {
    super.initState();
    _loadRentals();
  }

  Future<void> _loadRentals() async {
    var rentals = await _dbHelper.getRentals();
    setState(() {
      _rentals = rentals;
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
      body: _rentals.isEmpty
          ? Center(child: Text('Nenhum aluguel registrado.'))
          : ListView.builder(
        itemCount: _rentals.length,
        itemBuilder: (context, index) {
          Rent rent = _rentals[index];
          return ListTile(
            title: Text('Cliente: ${rent.client}'),
            subtitle: Text('De: ${DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(rent.startDate))} '
                'Até: ${DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(rent.endDate))}'),
            trailing: Text('R\$ ${rent.totalValue.toStringAsFixed(2)}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? registeredRent = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RentalRegistrationScreen()),
          );
          if (registeredRent == true) {
            _loadRentals();
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
    home: RentalsScreen(),
  ));
}
