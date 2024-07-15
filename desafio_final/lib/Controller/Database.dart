import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../Model/Client.dart';
import '../Model/Manager.dart';
import '../Model/Rent.dart';
import '../Model/User.dart';
import '../Model/Vehicle.dart';

/// Classe responsável pelas operações de banco de dados
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  DatabaseHelper.internal();
  /// Retorna a instância do banco de dados ou inicializa se não estiver
  /// disponível
  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await _initDb();
    return _db!;
  }

  /// Inicializa o banco de dados, criando ou abrindo o arquivo do banco
  Future<Database> _initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'app_database.db');

    return await openDatabase(path,
        version: 6, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  /// Cria as tabelas do banco de dados na versão inicial
  void _onCreate(Database db, int newVersion) async {
    await db.execute('PRAGMA foreign_keys = ON;');

    await db.execute('''
    CREATE TABLE User(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      lastname TEXT,
      email TEXT,
      password TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE Client(
      cnpj TEXT PRIMARY KEY,
      clientName TEXT,
      clientPhoneNumber INTEGER,
      city TEXT,
      clientState TEXT,
      cep TEXT, 
      managerCpf TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE Manager(
      cpf TEXT PRIMARY KEY,
      managerName TEXT,
      managerState TEXT,
      managerphoneNumber TEXT,
      percentage INTEGER
    )
    ''');

    await db.execute('''
    CREATE TABLE Vehicle (
      idVehicle INTEGER PRIMARY KEY AUTOINCREMENT,
      brand TEXT,
      model TEXT,
      plate TEXT,
      yearOfManufacture INTEGER,
      cost REAL,
      imagePath TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE Rent(
      idRent INTEGER PRIMARY KEY AUTOINCREMENT,
      client TEXT,
      startDate INTEGER,
      endDate INTEGER,
      numberOfDays INTEGER,
      totalValue REAL,
      vehiclePlate TEXT
    )
    ''');
  }

  /// Atualiza o banco de dados para novas versões, alterando as tabelas
  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
      ALTER TABLE Vehicle ADD COLUMN imagePath TEXT
    ''');

      await db.execute('''
      ALTER TABLE Client ADD COLUMN cep TEXT
    ''');
    }

    if (oldVersion < 3) {
      var tableInfo = await db.rawQuery('PRAGMA table_info(Client)');
      var columns =
      tableInfo.map((column) => column['name'] as String).toList();
      if (!columns.contains('managerCpf')) {
        await db.execute('''
        ALTER TABLE Client ADD COLUMN managerCpf TEXT
      ''');
      }
    }

    if (oldVersion < 4) {
      await db.execute('''
      CREATE TABLE Vehicle_temp (
        idVehicle INTEGER PRIMARY KEY AUTOINCREMENT,
        brand TEXT,
        model TEXT,
        plate TEXT,
        yearOfManufacture INTEGER,
        cost REAL,
        imagePath TEXT
      )
    ''');

      await db.execute('''
      INSERT INTO Vehicle_temp (idVehicle, brand, model, plate, yearOfManufacture, cost, imagePath)
      SELECT idVehicle, brand, model, plate, yearOfManufacture, cost, imagePath FROM Vehicle
    ''');

      await db.execute('DROP TABLE Vehicle');
      await db.execute('ALTER TABLE Vehicle_temp RENAME TO Vehicle');
    }

    if (oldVersion < 5) {
      await db.execute('''
      ALTER TABLE Rent ADD COLUMN vehiclePlate TEXT
    ''');

      if (oldVersion < 6) {
        await db.execute('''
    CREATE TABLE Rent_new(
      idRent INTEGER PRIMARY KEY AUTOINCREMENT,
      client TEXT,
      startDate INTEGER,
      endDate INTEGER,
      numberOfDays INTEGER,
      totalValue REAL,
      vehiclePlate TEXT
    )
  ''');

        await db.execute('''
    INSERT INTO Rent_new (idRent, client, startDate, endDate, numberOfDays, totalValue, vehiclePlate)
    SELECT idRent, client, startDate, endDate, numberOfDays, totalValue, vehiclePlate FROM Rent
  ''');

        await db.execute('DROP TABLE Rent');
        await db.execute('ALTER TABLE Rent_new RENAME TO Rent');
      }

    }
  }


  // Operações para Usuário

  /// Insere um novo usuário no banco de dados
  Future<int> saveUser(User user) async {
    var dbClient = await db;
    return await dbClient.insert('User', user.toMap());
  }

  /// Retorna a lista de todos os usuários no banco de dados
  Future<List<User>> getUsers() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('User',
        columns: ['id', 'name', 'lastname', 'email', 'password']);
    List<User> users = [];
    for (var map in maps) {
      users.add(User.fromMap(map as Map<String, dynamic>));
    }
    return users;
  }

  /// Deleta um usuário do banco de dados pelo id
  Future<int> deleteUser(int id) async {
    var dbClient = await db;
    return await dbClient.delete('User', where: 'id = ?', whereArgs: [id]);
  }

  /// Atualiza um usuário existente no banco de dados
  Future<int> updateUser(User user) async {
    var dbClient = await db;
    return await dbClient
        .update('User', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  // Operações para Cliente

  /// Insere um novo cliente no banco de dados
  /// Associa automaticamente um gerente baseado no estado do cliente
  Future<int> saveClient(Client client) async {
    var dbClient = await db;

    Manager? manager = await getManagerByState(client.clientState);
    if (manager != null) {
      client.managerCpf = manager.cpf;
    }

    return await dbClient.insert('Client', client.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Retorna a lista de todos os clientes no banco de dados
  Future<List<Client>> getClients() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('Client', columns: [
      'cnpj',
      'clientName',
      'clientPhoneNumber',
      'city',
      'clientState',
      'cep'
    ]);
    List<Client> clients = [];
    for (var map in maps) {
      clients.add(Client.fromMap(map as Map<String, dynamic>));
    }
    return clients;
  }

  /// Retorna um cliente pelo CNPJ
  Future<Client?> getClientByCnpj(String cnpj) async {
    var dbClient = await db;
    List<Map<String, dynamic>> result = await dbClient.query(
      'Client',
      where: 'cnpj = ?',
      whereArgs: [cnpj],
    );
    if (result.isNotEmpty) {
      return Client.fromMap(result.first);
    }
    return null;
  }

  /// Deleta um cliente do banco de dados pelo CNPJ
  Future<int> deleteClient(String cnpj) async {
    var dbClient = await db;
    return await dbClient
        .delete('Client', where: 'cnpj = ?', whereArgs: [cnpj]);
  }

  /// Atualiza um cliente existente no banco de dados
  Future<int> updateClient(Client client) async {
    var dbClient = await db;
    return await dbClient.update('Client', client.toMap(),
        where: 'cnpj = ?', whereArgs: [client.cnpj]);
  }

  // Operações para Gerente

  /// Insere um novo gerente no banco de dados
  Future<void> saveManager(Manager manager) async {
    var dbClient = await db;
    await dbClient.insert('Manager', manager.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Retorna a lista de todos os gerentes no banco de dados
  Future<List<Manager>> getManagers() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query('Manager');
    List<Manager> managers = [];
    for (var map in maps) {
      managers.add(Manager.fromMap(map));
    }
    return managers;
  }

  /// Deleta um gerente do banco de dados pelo CPF
  Future<void> deleteManager(String cpf) async {
    var dbClient = await db;
    await dbClient.delete('Manager', where: 'cpf = ?', whereArgs: [cpf]);
  }

  /// Atualiza um gerente existente no banco de dados
  Future<int> updateManager(Manager manager) async {
    var dbClient = await db;
    return await dbClient.update(
      'Manager',
      manager.toMap(),
      where: 'cpf = ?',
      whereArgs: [manager.cpf],
    );
  }

  /// Retorna um gerente baseado no estado
  Future<Manager?> getManagerByState(String state) async {
    var dbClient = await db;
    List<Map<String, dynamic>> result = await dbClient.query(
      'Manager',
      where: 'managerState = ?',
      whereArgs: [state],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return Manager.fromMap(result.first);
    }
    return null;
  }

  // Operações para Veículo

  /// Insere um novo veículo no banco de dados
  Future<int> saveVehicle(Vehicle vehicle) async {
    var dbClient = await db;
    return await dbClient.insert('Vehicle', vehicle.toMap());
  }

  /// Retorna a lista de todos os veículos no banco de dados
  Future<List<Vehicle>> getVehicles() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query('Vehicle');
    return List.generate(maps.length, (i) {
      return Vehicle.fromMap(maps[i]);
    });
  }

  /// Retorna um veículo do banco de dados com base na placa fornecida
  Future<Vehicle?> getVehicleByPlate(String plate) async {
    var dbClient = await db;
    List<Map<String, dynamic>> result = await dbClient.query(
      'Vehicle',
      where: 'plate = ?',
      whereArgs: [plate],
    );
    if (result.isNotEmpty) {
      return Vehicle.fromMap(result.first);
    }
    return null;
  }

  /// Deleta um veículo do banco de dados com base na placa fornecida
  Future<int> deleteVehicle(String plate) async {
    var dbClient = await db;
    return await dbClient
        .delete('Vehicle', where: 'plate = ?', whereArgs: [plate]);
  }

  /// Atualiza um veículo no banco de dados
  Future<int> updateVehicle(Vehicle vehicle) async {
    var dbClient = await db;
    return await dbClient.update('vehicle', vehicle.toMap(),
        where: 'plate = ?', whereArgs: [vehicle.plate]);
  }

  // Operações para Aluguel

  /// Retorna os detalhes do aluguel com base no ID do aluguel fornecido
  Future<Map<String, dynamic>> getRentDetails(int idRent) async {
    var dbClient = await db;
    List<Map<String, dynamic>> result = await dbClient.rawQuery('''
    SELECT a.idRent, a.client, a.startDate, a.endDate, a.numberOfDays, a.totalValue, a.vehiclePlate,
           c.clientName, c.clientPhoneNumber, c.city, c.clientState, c.cep, c.managerCpf,
           v.brand, v.model, v.plate, v.yearOfManufacture, v.cost, v.imagePath,
           g.managerName, g.managerState, g.managerPhoneNumber, g.percentage
    FROM Rent a
    JOIN Client c ON a.client = c.cnpj
    JOIN Vehicle v ON a.vehiclePlate = v.plate
    JOIN Manager g ON c.managerCpf = g.cpf
    WHERE a.idRent = ?
  ''', [idRent]);

    if (result.isNotEmpty) {
      return result.first;
    }
    return {};
  }

  /// Insere um novo aluguel no banco de dados
  Future<int> saveRent(Rent rent) async {
    var dbClient = await db;
    return await dbClient.insert('Rent', rent.toMap());
  }

  /// Retorna a lista de todos os aluguéis no banco de dados
  Future<List<Rent>> getRentals() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('Rent', columns: [
      'idRent',
      'client',
      'startDate',
      'endDate',
      'numberOfDays',
      'totalValue',
      'vehiclePlate'
    ]);
    List<Rent> rentals = [];
    for (var map in maps) {
      rentals.add(Rent.fromMap(map as Map<String, dynamic>));
    }
    return rentals;
  }

  /// Deleta um aluguel do banco de dados com base no ID do aluguel fornecido
  Future<int> deleteRent(int idRent) async {
    var dbClient = await db;
    return await dbClient
        .delete('Rent', where: 'idRent = ?', whereArgs: [idRent]);
  }

  /// Atualiza um aluguel no banco de dados
  Future<int> updateRent(Rent rent) async {
    var dbClient = await db;
    return await dbClient.update('Rent', rent.toMap(),
        where: 'idRent = ?', whereArgs: [rent.idRent]);
  }
}

