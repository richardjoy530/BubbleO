import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:BubbleO/Events/TriggerFunctions.dart';
import 'package:BubbleO/model/CustomBluetoothDevice.dart';
import 'package:BubbleO/model/db_helper.dart';
import 'package:BubbleO/ui/widgets.dart';
import 'package:BubbleO/utils/Logger.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

List<Device> devices = [];

class Device extends CustomBluetoothDevice {
  int deviceId = -1;
  late String deviceName;

  int _elapsedSec = 0;
  bool isStopped = true;
  bool isPaused = false;
  Timer? _timer;
  String statusText = "Disinfecting";

  Duration mainDuration = Duration();

  Device.createNew(this.deviceName, String _bluetoothAddress,
      BluetoothDevice _bluetoothDevice) {
    writeLog(
        "Device::createNew() ctor $deviceName-$_bluetoothAddress", Log.INFO);
    this.bluetoothAddress = _bluetoothAddress;
    this.bluetoothDevice = _bluetoothDevice;
    DataBaseHelper.addDevice(this).then((value) {
      writeLog("Device::createNew() Added to Database with deviceID: $value",
          Log.INFO);
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
    writeLog(
        "Device::createFromDB() ctor $deviceId-$deviceName-$bluetoothAddress",
        Log.INFO);
    this.deviceId = deviceId;
    this.deviceName = deviceName;
    this.bluetoothAddress = bluetoothAddress;
  }

  void onMessageReceived(Uint8List data) {
    print(data);
    if (utf8.decode(data) == "m") motionDetectedPopUp(this);
    writeLog("Device::onMessageReceived() -> $data", Log.INFO);
  }

  Future<bool> connect() async {
    writeLog("Device::connect()", Log.INFO);
    return await establishConnection(onMessageReceived);
  }

  void setTimer(Duration duration) {
    mainDuration = duration;
    writeLog("Device::setTimer() ${mainDuration.toString().substring(0, 7)}",
        Log.INFO);
  }

  void startTimer(void onFinish()) {
    writeLog("Device::startTimer() Enter", Log.INFO);
    writeLog(
        "Device::startTimer() Timer duration set for: ${mainDuration.toString().substring(0, 7)}",
        Log.INFO);
    sendMessage(mainDuration.inMinutes.toString());
    isStopped = false;
    isPaused = false;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      print(Events.setStates.length);
      if (!isPaused && !isStopped) {
        _elapsedSec += 1;
        writeLog(
            "Device::startTimer() Tick on $deviceName-$bluetoothAddress Elapsed time is: ${Duration(seconds: _elapsedSec).toString().substring(0, 7)} ",
            Log.INFO);
      }
      Events.setStates.forEach((function) {
        function.call();
      });
      if (_elapsedSec == mainDuration.inSeconds) {
        _timer?.cancel();
        isStopped = true;
        isPaused = false;
        onFinish.call();
        _elapsedSec = 0;
        writeLog("Device::startTimer() Finished", Log.INFO);
      }
    });
    writeLog("Device::startTimer() Exit", Log.INFO);
  }

  void playTimer() {
    writeLog("Device::pauseTimer() Enter", Log.INFO);
    writeLog(
        "Device::pauseTimer() remaining time is: ${getRemainingTime().toString().substring(0, 7)}",
        Log.INFO);
    sendMessage("p");
    isStopped = false;
    isPaused = false;
    writeLog("Device::pauseTimer() Exit", Log.INFO);
  }

  void pauseTimer() {
    writeLog("Device::pauseTimer() Enter", Log.INFO);
    writeLog(
        "Device::pauseTimer() Elapsed time is: ${Duration(seconds: _elapsedSec).toString().substring(0, 7)}",
        Log.INFO);
    sendMessage("h");
    isPaused = true;
    isStopped = false;
    writeLog("Device::pauseTimer() Exit", Log.INFO);
  }

  void stopTimer({bool send = true}) {
    writeLog("Device::stopTimer() Enter", Log.INFO);
    writeLog(
        "Device::stopTimer() Elapsed time is: ${Duration(seconds: _elapsedSec).toString().substring(0, 7)}",
        Log.INFO);
    if (send) sendMessage("s");
    isStopped = true;
    isPaused = false;
    _timer?.cancel();
    _elapsedSec = 0;
    Events.setStates.forEach((function) {
      function.call();
    });
    writeLog("Device::stopTimer() Exit", Log.INFO);
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

  void rename(String name) {
    this.deviceName = name;
    DataBaseHelper.updateDevice(this);
  }
}
