import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'dart:io';
import '../Controller/Database.dart';
import '../Model/Rent.dart';
import '../Model/Client.dart';
import '../Model/Manager.dart';
import '../Model/Vehicle.dart';
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
  /// Carrega os aluguéis do banco de dados e atualiza o estado da tela
  Future<void> _loadRentals() async {
    var rentals = await _dbHelper.getRentals();
    setState(() {
      _rentals = rentals;
    });
  }
  /// Deleta um aluguel do banco de dados e atualiza a lista de aluguéis exibida
  void _deleteRent(int idRent) async {
    await _dbHelper.deleteRent(idRent);
    setState(() {
      _loadRentals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aluguéis'),
      ),
      body: _rentals.isEmpty
          ? Center(child: Text('Nenhum aluguel registrado.'))
          : ListView.builder(
        itemCount: _rentals.length,
        itemBuilder: (context, index) {
          Rent rent = _rentals[index];
          return FutureBuilder<Client?>(
            future: _dbHelper.getClientByCnpj(rent.client),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError || !snapshot.hasData) {
                return ListTile(
                  title: Text('Erro ao carregar cliente'),
                );
              } else {
                Client? client = snapshot.data;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RentalRegistrationScreen(rent: rent),
                      ),
                    ).then((result) {
                      if (result == true) {
                        _loadRentals();
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
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
                                'Cliente: ${client?.clientName ?? 'Desconhecido'}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                  'Data de Início: ${DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(rent.startDate))}'),
                              Text(
                                  'Data de Término: ${DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(rent.endDate))}'),
                              Text('Total de Dias: ${rent.numberOfDays}'),
                              Text(
                                  'Valor Total: R\$ ${rent.totalValue.toStringAsFixed(2)}'),
                              Text('Placa do Veículo: ${rent.vehiclePlate}'),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.picture_as_pdf),
                          onPressed: () async {
                            Manager? manager = await _dbHelper
                                .getManagerByState(client!.clientState);
                            Vehicle? vehicle = await _dbHelper
                                .getVehicleByPlate(rent.vehiclePlate);

                            final pdfLib.Document pdf = pdfLib.Document();
                            pdf.addPage(
                              pdfLib.Page(
                                build: (pdfLib.Context context) =>
                                    pdfLib.Column(
                                      crossAxisAlignment:
                                      pdfLib.CrossAxisAlignment.start,
                                      children: [
                                        pdfLib.Center(
                                          child: pdfLib.Text(
                                            'SS Automóveis',
                                            style: pdfLib.TextStyle(
                                              fontSize: 24,
                                              fontWeight:
                                              pdfLib.FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        pdfLib.Center(
                                          child: pdfLib.Text(
                                            'Comprovante de Aluguel',
                                            style: pdfLib.TextStyle(
                                              fontSize: 20,
                                              fontWeight:
                                              pdfLib.FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        pdfLib.SizedBox(height: 20),
                                        pdfLib.Text(
                                          'Data da geração: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
                                          style: pdfLib.TextStyle(
                                              fontSize: 12),
                                        ),
                                        pdfLib.SizedBox(height: 20),
                                        pdfLib.Text('Dados do Cliente:',
                                            style: pdfLib.TextStyle(
                                                fontWeight:
                                                pdfLib.FontWeight.bold)),
                                        pdfLib.Text(
                                            'Nome: ${client.clientName}'),
                                        pdfLib.Text(
                                            'CNPJ: ${client.cnpj}'),
                                        pdfLib.Text(
                                            'Telefone: ${client.clientPhoneNumber}'),
                                        pdfLib.Text(
                                            'Endereço: ${client.cep}'),
                                        pdfLib.SizedBox(height: 20),
                                        pdfLib.Text('Dados do Veículo:',
                                            style: pdfLib.TextStyle(
                                                fontWeight:
                                                pdfLib.FontWeight.bold)),
                                        pdfLib.Text(
                                            'Placa: ${vehicle!.plate}'),
                                        pdfLib.Text(
                                            'Marca: ${vehicle.brand}'),
                                        pdfLib.Text(
                                            'Modelo: ${vehicle.model}'),
                                        pdfLib.Text(
                                            'Ano: ${vehicle.yearOfManufacture}'),
                                        pdfLib.SizedBox(height: 20),
                                        if (vehicle.imagePath != null)
                                          pdfLib.Image(
                                            pdfLib.MemoryImage(File(
                                                vehicle.imagePath!)
                                                .readAsBytesSync()),
                                            width: 200,
                                            height: 150,
                                          ),
                                        pdfLib.SizedBox(height: 20),
                                        pdfLib.Text('Dados do Gerente:',
                                            style: pdfLib.TextStyle(
                                                fontWeight:
                                                pdfLib.FontWeight.bold)),
                                        pdfLib.Text(
                                            'Nome: ${manager!.managerName}'),
                                        pdfLib.Text(
                                            'Telefone: ${manager.managerphoneNumber}'),
                                        pdfLib.Text(
                                            'Estado: ${manager.managerState}'),
                                        pdfLib.SizedBox(height: 20),
                                        pdfLib.Text('Período do Aluguel:',
                                            style: pdfLib.TextStyle(
                                                fontWeight:
                                                pdfLib.FontWeight.bold)),
                                        pdfLib.Text(
                                            'Início: ${DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(rent.startDate))}'),
                                        pdfLib.Text(
                                            'Término: ${DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(rent.endDate))}'),
                                        pdfLib.SizedBox(height: 20),
                                        pdfLib.Text(
                                            'Total de Dias: ${rent.numberOfDays}'),
                                        pdfLib.Text(
                                            'Valor da Diária: R\$ ${(rent.totalValue / rent.numberOfDays).toStringAsFixed(2)}'),
                                        pdfLib.Text(
                                            'Valor Total do Aluguel: R\$ ${rent.totalValue.toStringAsFixed(2)}'),
                                        pdfLib.Text(
                                            'Comissão do Gerente: R\$ ${(rent.totalValue * (manager.percentage / 100)).toStringAsFixed(2)}'),
                                      ],
                                    ),
                              ),
                            );

                            final String dir =
                                (await getApplicationDocumentsDirectory())
                                    .path;
                            final String path =
                                '$dir/comprovante_${rent.idRent}.pdf';
                            final File file = File(path);
                            await file.writeAsBytes(await pdf.save());

                            Share.shareFiles([path],
                                text: 'Comprovante de Aluguel');
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Deletar aluguel?'),
                                  content: Text(
                                      'Tem certeza que deseja deletar o aluguel do cliente ${client?.clientName ?? 'Desconhecido'}?'),
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
                                        if (rent.idRent != null) {
                                          _deleteRent(rent.idRent!);
                                        } else {
                                          print('Erro: idRent é nulo');
                                        }
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RentalRegistrationScreen(rent: null)),
          ).then((result) {
            if (result == true) {
              _loadRentals();
            }
          });
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
