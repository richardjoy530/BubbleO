import 'dart:io';

import 'package:BubbleO/utils/Logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'Device.dart';

class DataBaseHelper {
  static Database? _db;

  static initializeDatabase() async {
    writeLog("DataBaseHelper::initializeDatabase() Enter", Log.INFO);
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'bubbleo.db';
    _db = await openDatabase(path, version: 1, onCreate: _createDb);
    writeLog(
        "DataBaseHelper::initializeDatabase() Database successfully opened",
        Log.INFO);
    writeLog("DataBaseHelper::initializeDatabase() Exit", Log.INFO);
  }

  static _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE Devices (id INTEGER PRIMARY KEY AUTOINCREMENT, deviceName TEXT, bluetoothAddress TEXT settings TEXT)');
    writeLog("DataBaseHelper::_createDb() DataBase Created", Log.INFO);
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
          deviceId: map['id'] as int,
          deviceName: map["deviceName"].toString(),
          bluetoothAddress: map["bluetoothAddress"].toString()));
    }
    writeLog(
        "DataBaseHelper::getAllDevices() retrieved ${devices.length} devices",
        Log.INFO);
    return devices;
  }
}
