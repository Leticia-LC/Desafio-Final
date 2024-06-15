import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'Aluguel.dart';
import 'Usuario.dart';
import 'Cliente.dart';
import 'Gerente.dart';
import 'Veiculo.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'app_database.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE Usuario(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        lastname TEXT,
        email TEXT,
        password TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Cliente(
        cnpj TEXT PRIMARY KEY,
        clientName TEXT,
        clientPhoneNumber INTEGER,
        city TEXT,
        clientState TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Gerente(
        cpf TEXT PRIMARY KEY,
        managerName TEXT,
        managerState TEXT,
        managerphoneNumber TEXT,
        percentage INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE Veiculo(
        placa TEXT PRIMARY KEY,
        marca TEXT,
        modelo TEXT,
        anoFabricacao INTEGER,
        custo INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE Aluguel(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cliente TEXT,
        dataInicio INTEGER,
        dataTermino INTEGER,
        numeroDias INTEGER,
        valorTotal INTEGER
      )
    ''');
  }

  // Operações para Usuário
  Future<int> saveUsuario(Usuario usuario) async {
    var dbClient = await db;
    return await dbClient.insert('Usuario', usuario.toMap());
  }

  Future<List<Usuario>> getUsuarios() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('Usuario',
        columns: ['id', 'name', 'lastname', 'email', 'password']);
    List<Usuario> usuarios = [];
    for (var map in maps) {
      usuarios.add(Usuario.fromMap(map as Map<String, dynamic>));
    }
    return usuarios;
  }

  Future<int> deleteUsuario(int id) async {
    var dbClient = await db;
    return await dbClient.delete('Usuario', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateUsuario(Usuario usuario) async {
    var dbClient = await db;
    return await dbClient.update('Usuario', usuario.toMap(),
        where: 'id = ?', whereArgs: [usuario.id]);
  }

  // Operações para Cliente
  Future<int> saveCliente(Cliente cliente) async {
    var dbClient = await db;
    return await dbClient.insert('Cliente', cliente.toMap());
  }

  Future<List<Cliente>> getClientes() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('Cliente', columns: [
      'cnpj',
      'clientName',
      'clientPhoneNumber',
      'city',
      'clientState'
    ]);
    List<Cliente> clientes = [];
    for (var map in maps) {
      clientes.add(Cliente.fromMap(map as Map<String, dynamic>));
    }
    return clientes;
  }

  Future<int> deleteCliente(String cnpj) async {
    var dbClient = await db;
    return await dbClient
        .delete('Cliente', where: 'cnpj = ?', whereArgs: [cnpj]);
  }

  Future<int> updateCliente(Cliente cliente) async {
    var dbClient = await db;
    return await dbClient.update('Cliente', cliente.toMap(),
        where: 'cnpj = ?', whereArgs: [cliente.cnpj]);
  }

  // Operações para Gerente
  Future<int> saveGerente(Gerente gerente) async {
    var dbClient = await db;
    return await dbClient.insert('Gerente', gerente.toMap());
  }

  Future<List<Gerente>> getGerentes() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('Gerente', columns: [
      'cpf',
      'managerName',
      'managerState',
      'managerphoneNumber',
      'percentage'
    ]);
    List<Gerente> gerentes = [];
    for (var map in maps) {
      gerentes.add(Gerente.fromMap(map as Map<String, dynamic>));
    }
    return gerentes;
  }

  Future<int> deleteGerente(String cpf) async {
    var dbClient = await db;
    return await dbClient.delete('Gerente', where: 'cpf = ?', whereArgs: [cpf]);
  }

  Future<int> updateGerente(Gerente gerente) async {
    var dbClient = await db;
    return await dbClient.update('Gerente', gerente.toMap(),
        where: 'cpf = ?', whereArgs: [gerente.cpf]);
  }

  // Operações para Veículo
  Future<int> saveVeiculo(Veiculo veiculo) async {
    var dbClient = await db;
    return await dbClient.insert('Veiculo', veiculo.toMap());
  }

  Future<List<Veiculo>> getVeiculos() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('Veiculo',
        columns: ['placa', 'marca', 'modelo', 'anoFabricacao', 'custo']);
    List<Veiculo> veiculos = [];
    for (var map in maps) {
      veiculos.add(Veiculo.fromMap(map as Map<String, dynamic>));
    }
    return veiculos;
  }

  Future<int> deleteVeiculo(String placa) async {
    var dbClient = await db;
    return await dbClient
        .delete('Veiculo', where: 'placa = ?', whereArgs: [placa]);
  }

  Future<int> updateVeiculo(Veiculo veiculo) async {
    var dbClient = await db;
    return await dbClient.update('Veiculo', veiculo.toMap(),
        where: 'placa = ?', whereArgs: [veiculo.placa]);
  }

  //Operações para Aluguel
  Future<int> saveAlugueis(Aluguel aluguel) async {
    var dbAluguel = await db;
    return await dbAluguel.insert('Aluguel', aluguel.toMap());
  }

  Future<List<Aluguel>> getAlugueis() async {
    var dbAluguel = await db;
    List<Map> maps = await dbAluguel.query('Aluguel', columns: [
      'cliente',
      'dataInicio',
      'dataTermino',
      'numeroDias',
      'valorTotal'
    ]);
    List<Aluguel> alugueis = [];
    for (var map in maps) {
      alugueis.add(Aluguel.fromMap(map as Map<String, dynamic>));
    }
    return alugueis;
  }

  Future<int> deleteAlugueis(Aluguel aluguel) async {
    var dbAluguel = await db;
    return await dbAluguel
        .delete('Aluguel', where: 'id = ?', whereArgs: [aluguel]);
  }

  Future<int> updateAluguel(Aluguel aluguel) async {
    var dbAluguel = await db;
    return await dbAluguel.update('Aluguel', aluguel.toMap(),
       where: 'aluguel = ?', whereArgs: [aluguel.id]);

  }
}
