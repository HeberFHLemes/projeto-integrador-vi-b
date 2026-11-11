import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'schema.dart';

/// Componente Singleton para gerenciar a conexão com o banco de dados
final class DatabaseHelper {

  static const int _databaseVersion = 1;
  static const String _databaseName = 'agendados.db';

  // Singleton
  static final DatabaseHelper instance = DatabaseHelper._internal();

  DatabaseHelper._internal();

  static Future<Database>? _database;

  Future<Database> get database async {
    return _database ??= _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);

    return openDatabase(
      path,
      version: _databaseVersion,
      onConfigure: _configureDb,
      onCreate: _createDb,
    );
  }

  Future<void> _configureDb(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _createDb(Database db, int version) async {
    await createSchema(db); // schema.dart
  }
}