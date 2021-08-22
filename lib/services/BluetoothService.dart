import 'package:BubbleO/model/Device.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothService {
  static FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;

  static scan() async {
    List<BluetoothDevice> bluetoothDevices = await bluetooth.getBondedDevices();
    for (var bluetoothDevice in bluetoothDevices) {
      for (var device in devices) {
        if (device.bluetoothAddress == bluetoothDevice.address) {
          device.bluetoothDevice = bluetoothDevice;
        }
      }
    }
  }

  static Future<List<BluetoothDevice>> getPairedDevices() async {
    return await bluetooth.getBondedDevices();
  }

  static registerNewDevice(
      BluetoothDevice _bluetoothDevice, String _deviceName) {
    Device.createNew(_deviceName, _bluetoothDevice.address, _bluetoothDevice);
  }
}
