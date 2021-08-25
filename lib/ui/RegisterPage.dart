import 'package:BubbleO/services/BluetoothService.dart';
import 'package:BubbleO/utils/Logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  List<BluetoothDevice> bluetoothDevices = [];

  @override
  void initState() {
    writeLog(
        "RegisterPage::initState() fetching list of paired bluetooth devices",
        Log.INFO);
    BluetoothService.getPairedDevices().then((value) {
      setState(() {
        bluetoothDevices = value;
        writeLog(
            "RegisterPage::initState() found $value paired devices", Log.INFO);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
          Container(
            margin: EdgeInsets.only(top: 30),
            child: ListTile(
              title: Text(
                "Bluetooth",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w400),
              ),
            ),
          ),
          Container(
            child: ListTile(
              title: Text(
                "Select the device you want to register",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: ListView.builder(
                      itemCount: bluetoothDevices.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                            child: ListTile(
                              leading: Icon(
                                Icons.bluetooth_rounded,
                              ),
                              title: Text(bluetoothDevices[index].name!),
                              onTap: () {
                                setState(() {
                                  writeLog("RegisterPage::onTapRegister()",
                                      Log.INFO);
                                  BluetoothService.registerNewDevice(
                                      bluetoothDevices[index],
                                      bluetoothDevices[index].name!);
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                      }))),
          Container(
            margin: EdgeInsets.only(bottom: 20, left: 14, right: 14),
            child: ListTile(
              title: Text(
                "Refresh list",
                style: TextStyle(fontSize: 14),
              ),
              trailing: Icon(
                Icons.refresh_rounded,
              ),
            ),
          ),
        ])));
  }
}
