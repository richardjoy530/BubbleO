import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class Device {
  String deviceName;
  String bluetoothAddress; // Bluetooth  MAC address
  int deviceId = -1;
  BluetoothConnection? bluetoothConnection;
  BluetoothDevice? bluetoothDevice;

  Device(this.deviceName, this.bluetoothAddress);

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
