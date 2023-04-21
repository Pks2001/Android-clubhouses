import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "mydatabase.db";
  static final _databaseVersion = 1;

  static final table = 'rooms';

  static final columnId = '_id';
  static final columnName = 'name';
  static final columnCode = 'code';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async =>
      _database ??= await _initDatabase();

  String get tableRooms => '';

  // open the database
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL
          )
          ''');
  }

  // Helper methods

  // Inserts a new room record into the database
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // Returns all the rooms in the database
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<Map<String, dynamic>?> getRoomByCode(String code) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      tableRooms,
      where: "$columnCode = ?",
      whereArgs: [code],
    );
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

}
