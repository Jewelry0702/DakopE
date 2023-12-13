import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton instance of the DatabaseHelper class
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Database file name
  static const String _databaseName = "edakop.db";

  // Database instance
  static Database? _database;

  DatabaseHelper._privateConstructor();

  // Initialize the database and return the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database by opening or creating it
  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);
    return await openDatabase(
      path,
      version:
          1, // You can increase the version number when you need to upgrade the database schema.
      onCreate: _onCreate,
    );
  }

  // Define the database schema in the onCreate callback
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE info (
        plateNum TEXT,
        ownerName TEXT,
        model TEXT,
        CRNum TEXT,
        permitNum TEXT,
        isExpired BOOLEAN
      );
      

    ''');

    await db.execute('''
      CREATE TABLE ticket (
        plateNum TEXT,
        ownerName TEXT,
        model TEXT,
        CRNum TEXT,
        permitNum TEXT,
        date TEXT,
        place TEXT,
        violation, TEXT
      );
      

    ''');
  }

  Future<int> insertViolation(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('ticket', row);
  }

  // Insert a new record into the database
  Future<int> insert(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('info', row);
  }

  // Query all records from the database
  Future<List<Map<String, dynamic>>> queryAll() async {
    final db = await database;
    return await db.query('info');
  }

  Future<List<Map<String, dynamic>>> queryAllViolation() async {
    final db = await database;
    return await db.query('ticket');
  }

  Future<List<Map<String, dynamic>>> getDataFromPlateNum(
      String plateNum) async {
    final db = await database;
    return await db.query('info',
        columns: ['ownerName', 'model', 'CRNum', 'permitNum', 'isExpired'],
        where: 'plateNum = ?',
        whereArgs: [plateNum],
        limit: 1);
  }

  Future<void> deleteAllEntries() async {
    final db = await database;
    await db.delete('info');
  }
}
