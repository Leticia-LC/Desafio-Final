import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'Usuario.dart';
import 'Cliente.dart';

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
  }

  // Operações para Usuário
  Future<int> saveUsuario(Usuario usuario) async {
    var dbClient = await db;
    return await dbClient.insert('Usuario', usuario.toMap());
  }

  Future<List<Usuario>> getUsuarios() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('Usuario', columns: ['id', 'name', 'lastname', 'email', 'password']);
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
    return await dbClient.update('Usuario', usuario.toMap(), where: 'id = ?', whereArgs: [usuario.id]);
  }

  // Operações para Cliente
  Future<int> saveCliente(Cliente cliente) async {
    var dbClient = await db;
    return await dbClient.insert('Cliente', cliente.toMap());
  }

  Future<List<Cliente>> getClientes() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('Cliente', columns: ['cnpj', 'clientName', 'clientPhoneNumber', 'city', 'clientState']);
    List<Cliente> clientes = [];
    for (var map in maps) {
      clientes.add(Cliente.fromMap(map as Map<String, dynamic>));
    }
    return clientes;
  }

  Future<int> deleteCliente(String cnpj) async {
    var dbClient = await db;
    return await dbClient.delete('Cliente', where: 'cnpj = ?', whereArgs: [cnpj]);
  }

  Future<int> updateCliente(Cliente cliente) async {
    var dbClient = await db;
    return await dbClient.update('Cliente', cliente.toMap(), where: 'cnpj = ?', whereArgs: [cliente.cnpj]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
