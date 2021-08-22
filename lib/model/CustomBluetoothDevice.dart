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

  void establishConnection(void callback(Uint8List data)) {
    BluetoothConnection.toAddress(bluetoothAddress).then((_connection) {
      bluetoothConnection = _connection;
      bluetoothConnection.input!.listen(callback);
    });
  }

  bool isConnected() {
    return bluetoothDevice.isConnected;
  }
}
