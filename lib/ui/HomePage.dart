import 'package:BubbleO/Events/TriggerFunctions.dart';
import 'package:BubbleO/model/Device.dart';
import 'package:BubbleO/ui/InfoPage.dart';
import 'package:BubbleO/ui/RegisterPage.dart';
import 'package:BubbleO/ui/widgets.dart';
import 'package:BubbleO/utils/Logger.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StateFunction stateFunction = () {};

  @override
  void initState() {
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
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color(0xFFF9FBFF),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 30, bottom: 30),
            child: ListTile(
              title: Text(
                "BubbleO",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              trailing: IconButton(
                icon: Icon(Icons.add_rounded),
                onPressed: onMenuPressed,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)),
                  ),
                  child: ListView.builder(
                      itemCount: devices.length,
                      itemBuilder: (context, index) {
                        return genericTile(
                            text: devices[index].deviceName,
                            subTitle: devices[index].isStopped
                                ? null
                                : LinearPercentIndicator(
                                    lineHeight: 5.0,
                                    percent: devices[index]
                                            .getRemainingTime()
                                            .inSeconds /
                                        devices[index]
                                            .getTotalDuration()
                                            .inSeconds,
                                    progressColor: Colors.black,
                                  ),
                            color: Colors.white,
                            leadingIcon: Icons.wifi_tethering_rounded,
                            trailing: Icon(Icons.arrow_forward_ios_rounded),
                            onTap: () async {
                              writeLog(
                                  "HomePage::onTap() DeviceTile", Log.INFO);
                              var result = await devices[index].connect();
                              writeLog(
                                  "HomePage::onTap() ${devices[index].deviceName} connection status: $result",
                                  Log.INFO);
                              if (result)
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            InfoPage(devices[index])));
                            });
                      })),
            ),
          )
        ],
      ),
    ));
  }

  onMenuPressed() {
    writeLog("HomePage::onMenuPressed()", Log.INFO);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterPage()));
    // showModalBottomSheet(
    //     isScrollControlled: true,
    //     context: context,
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.only(
    //           topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
    //     ),
    //     builder: (context) {
    //       return Wrap(
    //         children: <Widget>[
    //           Divider(
    //             thickness: 2,
    //             indent: MediaQuery.of(context).size.width / 4,
    //             endIndent: MediaQuery.of(context).size.width / 4,
    //           ),
    //           Column(
    //             children: [
    //               ListTile(
    //                 leading: Icon(
    //                   Icons.add,
    //                 ),
    //                 title: Text('Add New Device',
    //                     style: TextStyle(
    //                         fontSize: 16, fontWeight: FontWeight.w300)),
    //                 onTap: () {
    //                   Navigator.push(
    //                       context,
    //                       MaterialPageRoute(
    //                           builder: (context) => RegisterPage()));
    //                 },
    //               ),
    //             ],
    //           ),
    //         ],
    //       );
    //     });
  }
}
