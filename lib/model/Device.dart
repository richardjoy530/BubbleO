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
  bool isStopped = true;
  bool isPaused = false;
  late Timer _timer;
  Duration _duration = Duration();

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
    isStopped = false;
    isPaused = false;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _timer = timer;
      if (!isPaused) _elapsedSec += 1;
      if (_elapsedSec == _duration.inSeconds) {
        _timer.cancel();
        onFinish.call();
        _elapsedSec = 0;
      }
    });
  }

  void playTimer() {
    isStopped = false;
    isPaused = false;
  }

  void pauseTimer() {
    isPaused = true;
    isStopped = false;
  }

  void stopTimer() {
    isStopped = true;
    isPaused = false;
    _timer.cancel();
    _elapsedSec = 0;
  }

  Duration getTotalDuration() {
    return _duration;
  }

  Duration getRemainingTime() {
    return Duration(seconds: _duration.inSeconds - _elapsedSec);
  }

  Duration getElapsedTime() {
    return Duration(seconds: _elapsedSec);
  }
}
