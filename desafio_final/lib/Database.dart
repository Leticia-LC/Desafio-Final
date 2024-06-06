import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'usuario.dart';

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
    final path = join(databasesPath, 'usuarios.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE Usuario(
        id INTEGER PRIMARY KEY,
        name TEXT,
        lastname TEXT,
        email TEXT,
        password TEXT
      )
    ''');
  }

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

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
