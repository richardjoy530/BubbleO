import 'dart:typed_data';

abstract class IDataListener {
  void onDataReceivedCallback(Uint8List data);
}
