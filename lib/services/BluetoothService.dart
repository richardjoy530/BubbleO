import 'package:BubbleO/model/Device.dart';
import 'package:BubbleO/utils/Logger.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothService {
  static FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;

  static scan() async {
    writeLog("BluetoothService::scan() Enter", Log.INFO);
    bluetooth.isEnabled.then((value) async {
      if (value == false) {
        writeLog("BluetoothService::scan() requesting to enable bluetooth",
            Log.INFO);
        bluetooth.requestEnable();
        await Future.delayed(Duration(seconds: 1));
      }
    });
    List<BluetoothDevice> bluetoothDevices = await bluetooth.getBondedDevices();
    for (var bluetoothDevice in bluetoothDevices) {
      for (var device in devices) {
        if (device.bluetoothAddress == bluetoothDevice.address) {
          device.bluetoothDevice = bluetoothDevice;
          writeLog(
              "BluetoothService::scan() Assigning bluetooth object for ${device.deviceName}",
              Log.INFO);
        }
      }
    }
    writeLog("BluetoothService::scan() Exit", Log.INFO);
  }

  static Future<List<BluetoothDevice>> getPairedDevices() async {
    writeLog("BluetoothService::getPairedDevices()", Log.INFO);
    return await bluetooth.getBondedDevices();
  }

  static registerNewDevice(
      BluetoothDevice _bluetoothDevice, String _deviceName) {
    writeLog("BluetoothService::registerNewDevice()", Log.INFO);
    Device.createNew(_deviceName, _bluetoothDevice.address, _bluetoothDevice);
  }
}
