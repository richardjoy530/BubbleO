import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:BubbleO/model/db_helper.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

List<Device> devices = [];

class Device {
  String? deviceName;
  String? bluetoothAddress; // Bluetooth  MAC address
  int deviceId = -1;
  BluetoothConnection? bluetoothConnection;
  BluetoothDevice? bluetoothDevice;

  Device(this.deviceName, this.bluetoothAddress);

  Device.createNew(
      this.deviceName, this.bluetoothAddress, this.bluetoothDevice) {
    DataBaseHelper.addDevice(this).then((value) => this.deviceId = value);
  }

  Device.createFromDB(this.bluetoothAddress, this.deviceName, {int? deviceId}) {
    this.deviceName = deviceName!;
    this.bluetoothAddress = bluetoothAddress!;
    this.deviceId = deviceId!;
  }

  void sendMessage(String data) {
    bluetoothConnection!.output.add(Uint8List.fromList(utf8.encode(data)));
  }

  void connect() {
    if (bluetoothConnection == null) {
      BluetoothConnection.toAddress(bluetoothAddress).then((_connection) {
        bluetoothConnection = _connection;
        bluetoothConnection!.input!.listen(onDataReceived);
      });
    }
  }

  void onDataReceived(Uint8List data) {
    print(data); // for debugging purpose
  }
}
