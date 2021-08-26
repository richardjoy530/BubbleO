import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

String downloadsPath = "";
late File _localFile;
late Queue<String> logQueue;

Future<void> initialiseLogger() async {
  logQueue = new Queue();
  const MethodChannel _channel = const MethodChannel('BubbleO_Channel');
  downloadsPath = await _channel.invokeMethod('getDownloadsDirectory');
  var time =
      (DateTime.now().microsecondsSinceEpoch / 1000).floor() % 1629900000;
  _localFile = File('$downloadsPath/bubble_o_debug$time.log');
  Fluttertoast.showToast(msg: "$downloadsPath/bubble_o_debug$time.log");
}

startLogger() async {
  writeLog("Logger started.... Interval = 5 sec", Log.INFO);
  while (true) {
    await Future.delayed(Duration(seconds: 5));
    while (logQueue.isNotEmpty)
      await _localFile.writeAsString(logQueue.removeFirst(),
          mode: FileMode.append);
  }
}

stopLogger() async {
  while (logQueue.isNotEmpty)
    await _localFile.writeAsString(logQueue.removeFirst(),
        mode: FileMode.append);
}

void writeLog(String msg, String level) {
  logQueue.add(DateTime.now().toString().substring(0, 19) + level + msg + "\n");
  print(DateTime.now().toString().substring(0, 19) + level + msg + "\n");
}

class Log {
  static const String INFO = " [INFO] ";
  static const String WARN = " [WARN] ";
  static const String ERROR = " [ERROR] ";
  static const String FATAL = " [FATAL] ";
}
