import 'package:BubbleO/model/data.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothService {
  static FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;

  scan() async {
    List<BluetoothDevice> bluetoothDevices = await bluetooth.getBondedDevices();
    for (var bluetoothDevice in bluetoothDevices) {
      for (var device in devices) {
        if (device.bluetoothAddress == bluetoothDevice.address) {
          device.bluetoothDevice = bluetoothDevice;
        }
      }
    }
  }

  static getPairedDevices() async {
    return await bluetooth.getBondedDevices();
  }

  registerNewDevice(BluetoothDevice _bluetoothDevice, String _deviceName) {
    Device.createNew(_deviceName, _bluetoothDevice.address, _bluetoothDevice);
  }
}
