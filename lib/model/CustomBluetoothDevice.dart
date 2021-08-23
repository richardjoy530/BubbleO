import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

abstract class CustomBluetoothDevice {
  late BluetoothDevice bluetoothDevice;
  late BluetoothConnection bluetoothConnection;
  late String bluetoothAddress;

  void sendMessage(String data) {
    bluetoothConnection.output.add(Uint8List.fromList(utf8.encode(data)));
  }

  // void onDataReceived(Uint8List data) {
  //   print(data); // for debugging purpose
  // }

  Future<bool> establishConnection(void callback(Uint8List data)) async {
    var connected = false;
    await BluetoothConnection.toAddress(bluetoothAddress).then((_connection) {
      bluetoothConnection = _connection;
      connected = true;
      bluetoothConnection.input!.listen(callback);
    });
    return connected;
  }

  bool isConnected() {
    return bluetoothDevice.isConnected;
  }
}
