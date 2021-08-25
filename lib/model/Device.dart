import 'dart:async';
import 'dart:core';
import 'dart:typed_data';

import 'package:BubbleO/Events/TriggerFunctions.dart';
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
  Duration mainDuration = Duration();

  Device.createNew(this.deviceName, String _bluetoothAddress,
      BluetoothDevice _bluetoothDevice) {
    this.bluetoothAddress = _bluetoothAddress;
    this.bluetoothDevice = _bluetoothDevice;
    DataBaseHelper.addDevice(this).then((value) {
      this.deviceId = value;
      devices.add(this);
      Events.setStates.forEach((function) {
        function.call();
      });
    });
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

  Future<bool> connect() async {
    return await establishConnection(onMessageReceived);
  }

  void setTimer(Duration duration) {
    mainDuration = duration;
  }

  void startTimer(void onFinish()) {
    sendMessage(mainDuration.inMinutes.toString());
    isStopped = false;
    isPaused = false;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      Events.setStates.forEach((function) {
        function.call();
      });
      print(Events.setStates.length);
      if (!isPaused && !isStopped) _elapsedSec += 1;
      if (_elapsedSec == mainDuration.inSeconds) {
        _timer.cancel();
        isStopped = true;
        isPaused = false;
        onFinish.call();
        _elapsedSec = 0;
      }
    });
  }

  void playTimer() {
    sendMessage("p");
    isStopped = false;
    isPaused = false;
  }

  void pauseTimer() {
    sendMessage("h");
    isPaused = true;
    isStopped = false;
  }

  void stopTimer() {
    sendMessage("s");
    isStopped = true;
    isPaused = false;
    _timer.cancel();
    _elapsedSec = 0;
    Events.setStates.forEach((function) {
      function.call();
    });
  }

  Duration getTotalDuration() {
    return mainDuration;
  }

  Duration getRemainingTime() {
    return Duration(seconds: mainDuration.inSeconds - _elapsedSec);
  }

  Duration getElapsedTime() {
    return Duration(seconds: _elapsedSec);
  }
}
