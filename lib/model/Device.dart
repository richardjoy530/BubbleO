import 'dart:async';
import 'dart:core';
import 'dart:typed_data';

import 'package:BubbleO/model/CustomBluetoothDevice.dart';
import 'package:BubbleO/model/db_helper.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

List<Device> devices = [];

class Device extends CustomBluetoothDevice {
  int deviceId = -1;
  late String deviceName;

  int _elapsedSec = 0;
  bool _isStopped = false;
  late Timer _timer;
  late Duration _duration;

  Device.createNew(this.deviceName, String _bluetoothAddress,
      BluetoothDevice _bluetoothDevice) {
    this.bluetoothAddress = _bluetoothAddress;
    this.bluetoothDevice = _bluetoothDevice;
    DataBaseHelper.addDevice(this).then((value) => this.deviceId = value);
  }

  Device.createFromDB({
    required int deviceId,
    required String deviceName,
    required String bluetoothAddress,
  }) {
    this.deviceId = deviceId;
    this.deviceName = deviceName;
    this.bluetoothAddress = bluetoothAddress;
  }

  void onMessageReceived(Uint8List data) {
    print(data);
  }

  void connect() {
    establishConnection(onMessageReceived);
  }

  void setTimer(Duration duration) {
    _duration = duration;
  }

  void startTimer(void onFinish()) {
    _isStopped = false;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _timer = timer;
      if (!_isStopped) _elapsedSec += 1;
      if (_elapsedSec == _duration.inSeconds) {
        _timer.cancel();
        onFinish.call();
      }
    });
  }

  void pauseTimer() {
    _isStopped = true;
  }

  void stopTimer() {
    _isStopped = true;
    _timer.cancel();
  }

  Duration getRemainingTime() {
    return Duration(seconds: _duration.inSeconds - _elapsedSec);
  }

  Duration getElapsedTime() {
    return Duration(seconds: _elapsedSec);
  }
}
