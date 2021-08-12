import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  static Database? _db;

  static initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'bubbleo.db';
    _db = await openDatabase(path, version: 1, onCreate: _createDb);
  }

  static _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE Devices (id INTEGER PRIMARY KEY AUTOINCREMENT, deviceName TEXT, bluetoothAddress TEXT settings TEXT)');
  }
}
