import 'package:BubbleO/Events/TriggerFunctions.dart';
import 'package:BubbleO/model/Device.dart';
import 'package:BubbleO/model/db_helper.dart';
import 'package:BubbleO/ui/DevicePage.dart';
import 'package:BubbleO/ui/RegisterPage.dart';
import 'package:BubbleO/ui/widgets.dart';
import 'package:BubbleO/utils/Logger.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'InfoPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StateFunction stateFunction = () {};

  @override
  void initState() {
    contextStack.add(this.context);
    stateFunction = () {
      setState(() {
        // writeLog("HomePage->setstate() refreshing", Log.INFO);
      });
    };
    Events.setStates.add(stateFunction);
    super.initState();
    writeLog("HomePage::initState()", Log.INFO);
  }

  @override
  void dispose() {
    contextStack.remove(this.context);
    devices.forEach((device) {
      device.bluetoothConnection?.close();
      device.bluetoothConnection?.dispose();
    });
    writeLog("HomePage::dispose()", Log.INFO);
    writeLog("----- Logger stopped -----", Log.INFO);
    stopLogger();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xFFF9FBFF),
          body: Column(
            children: [
              Container(
                margin:
                    EdgeInsets.only(top: 30, bottom: 30, left: 50, right: 50),
                child: ListTile(
                  title: Image.asset(
                    'assets/logo.png',
                    color: Color(0xff00477d),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xffeff3f5),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0)),
                      ),
                      child: ListView.builder(
                          itemCount: devices.length,
                          itemBuilder: (context, index) {
                            Color color = Colors.white;
                            return Listener(
                              onPointerDown: (event) {
                                setState(() {
                                  color = Colors.blueAccent;
                                });
                              },
                              onPointerUp: (event) {
                                setState(() {
                                  color = Colors.white;
                                });
                              },
                              child: genericTile(
                                  text: devices[index].deviceName,
                                  subTitle: devices[index].isStopped
                                      ? null
                                      : LinearPercentIndicator(
                                          backgroundColor: Color(0xffd6e7ee),
                                          lineHeight: 5.0,
                                          percent: devices[index]
                                                  .getRemainingTime()
                                                  .inSeconds /
                                              devices[index]
                                                  .getTotalDuration()
                                                  .inSeconds,
                                          progressColor: Color(0xff00477d),
                                        ),
                                  color: color,
                                  leadingIcon:
                                      devices[index].bluetoothConnection !=
                                                  null &&
                                              devices[index]
                                                  .bluetoothDevice
                                                  .isBonded
                                          ? Icons.bluetooth_connected_rounded
                                          : Icons.bluetooth_rounded,
                                  trailing: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Color(0xff00477d),
                                  ),
                                  onLongPress: () {
                                    options(devices[index]);
                                  },
                                  onTap: () async {
                                    writeLog("HomePage::onTap() DeviceTile",
                                        Log.INFO);
                                    var result = await devices[index].connect();
                                    writeLog(
                                        "HomePage::onTap() ${devices[index].deviceName} connection status: $result",
                                        Log.INFO);
                                    if (result) {
                                      if (devices[index].isStopped)
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    InfoPage(devices[index])));
                                      else
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DevicePage(
                                                        devices[index])));
                                      setState(() {});
                                    }
                                  }),
                            );
                          })),
                ),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Color(0xff00477d),
            onPressed: () {
              addDevice();
            },
            label: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.add),
                Text("Add Device"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit the App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  addDevice() {
    writeLog("HomePage::onMenuPressed()", Log.INFO);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterPage()));
  }

  options(Device device) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
        ),
        builder: (context) {
          return Wrap(
            children: <Widget>[
              Divider(
                thickness: 2,
                indent: MediaQuery.of(context).size.width / 4,
                endIndent: MediaQuery.of(context).size.width / 4,
              ),
              Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.drive_file_rename_outline,
                      color: Color(0xff00477d),
                    ),
                    title: Text('Rename Device',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300)),
                    onTap: () async {
                      Navigator.pop(context);
                      await renameDevicePopUp(device);
                      setState(() {});
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.delete_forever_rounded,
                      color: Color(0xff00477d),
                    ),
                    title: Text('Delete Device',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300)),
                    onTap: () async {
                      await device.bluetoothConnection?.close();
                      setState(() {
                        devices.remove(device);
                        DataBaseHelper.removeDevice(device);
                        Navigator.pop(context);
                      });
                    },
                  ),
                ],
              ),
            ],
          );
        });
  }
}
