import 'dart:convert';
import 'dart:typed_data';

import 'package:BubbleO/utils/Logger.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

abstract class CustomBluetoothDevice {
  late BluetoothDevice bluetoothDevice;
  BluetoothConnection? bluetoothConnection;
  late String bluetoothAddress;

  void sendMessage(String data) {
    writeLog("CustomBluetoothDevice::sendMessage()", Log.INFO);
    bluetoothConnection!.output.add(Uint8List.fromList(utf8.encode(data)));
    writeLog(
        "CustomBluetoothDevice::sendMessage() message sent: $data", Log.INFO);
  }

  // void onDataReceived(Uint8List data) {
  //   print(data); // for debugging purpose
  // }

  Future<bool> establishConnection(void callback(Uint8List data)) async {
    writeLog("CustomBluetoothDevice::establishConnection() Enter", Log.INFO);
    if (bluetoothConnection != null && bluetoothConnection!.isConnected) {
      writeLog("CustomBluetoothDevice::establishConnection() Already Connected",
          Log.INFO);
      print("Already Connected");
      return true;
    }

    var connected = false;
    await BluetoothConnection.toAddress(bluetoothAddress).then((_connection) {
      writeLog(
          "CustomBluetoothDevice::establishConnection() serial connection established to $bluetoothAddress:${bluetoothDevice.name}",
          Log.INFO);

      bluetoothConnection = _connection;
      connected = true;

      writeLog(
          "CustomBluetoothDevice::establishConnection() listening  for messages started...",
          Log.INFO);

      bluetoothConnection!.input!
        ..handleError((error) {
          writeLog(
              "CustomBluetoothDevice::establishConnection()..handleError()",
              Log.ERROR);
        })
        ..listen(callback).onError((error) {
          writeLog(
              "CustomBluetoothDevice::establishConnection()..listen().onError()",
              Log.ERROR);
        });

      print("connected to ${bluetoothDevice.name}");
      // sendMessage("7");
      // sendMessage("0");
    }).onError((error, stackTrace) {
      writeLog(
          "CustomBluetoothDevice::establishConnection().onError Error: Failed to connect",
          Log.ERROR);

      // Fluttertoast.showToast(
      //     msg: "Couldn't connect to: ${bluetoothDevice.name}");
    }).whenComplete(() {
      writeLog("CustomBluetoothDevice::establishConnection()->whenComplete() ",
          Log.WARN);
    });

    writeLog("CustomBluetoothDevice::establishConnection() Exit", Log.INFO);
    return connected;
  }

  bool isConnected() {
    writeLog(
        "CustomBluetoothDevice::isConnected() result:${bluetoothDevice.isConnected}",
        Log.INFO);
    return bluetoothDevice.isConnected;
  }
}
