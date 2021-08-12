import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'data.dart';

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

  static Future<int> addDevice(Device device) async =>
      await _db!.insert("Devices", {
        "deviceName": device.deviceName,
        "bluetoothAddress": device.bluetoothAddress
      });

  static Future<List<Device>> getAllDevices() async {
    List<Device> devices = [];
    var value = await _db!.query("Devices");
    for (var map in value) {
      devices.add(Device.createFromDB(
          map["deviceName"].toString(), map["bluetoothAddress"].toString(),
          deviceId: map['deviceId'] as int));
    }
    return devices;
  }
}
