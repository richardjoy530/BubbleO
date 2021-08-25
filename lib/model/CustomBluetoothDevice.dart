import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class CustomBluetoothDevice {
  late BluetoothDevice bluetoothDevice;
  BluetoothConnection? bluetoothConnection;
  late String bluetoothAddress;

  void sendMessage(String data) {
    bluetoothConnection!.output.add(Uint8List.fromList(utf8.encode(data)));
  }

  // void onDataReceived(Uint8List data) {
  //   print(data); // for debugging purpose
  // }

  Future<bool> establishConnection(void callback(Uint8List data)) async {
    if (bluetoothConnection != null && bluetoothConnection!.isConnected) {
      print("Already Connected");
      return true;
    }
    var connected = false;
    await BluetoothConnection.toAddress(bluetoothAddress).then((_connection) {
      bluetoothConnection = _connection;
      connected = true;
      bluetoothConnection!.input!.listen(callback);
      print("connected to ${bluetoothDevice.name}");
      sendMessage("7");
      sendMessage("0");
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(
          msg: "Couldn't connect to: ${bluetoothDevice.name}");
      print("Error: Failed to connect");
    });
    print("Returning");
    return connected;
  }

  bool isConnected() {
    return bluetoothDevice.isConnected;
  }
}
