import 'package:BubbleO/Events/TriggerFunctions.dart';
import 'package:BubbleO/model/Device.dart';
import 'package:BubbleO/ui/DevicePage.dart';
import 'package:BubbleO/ui/widgets.dart';
import 'package:BubbleO/utils/Logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class InfoPage extends StatefulWidget {
  final Device device;

  const InfoPage(this.device, {Key? key}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage>
    with SingleTickerProviderStateMixin {
  final customColor = CustomSliderColors(
    dotColor: Color(0xff02457a),
    progressBarColor: Color(0xffd6e7ee),
    hideShadow: true,
    trackColor: Color(0xff00477d),
    progressBarColors: [
      Color(0xff00477d),
      Color(0xff008bc0),
      Color(0xff97cadb),
    ],
  );
  StateFunction stateFunction = () {};

  @override
  void initState() {
    contextStack.add(this.context);
    writeLog("InfoPage::initState()", Log.INFO);
    stateFunction = () {
      setState(() {
        // writeLog("DevicePage->setstate() refreshing", Log.INFO);
      });
    };
    Events.setStates.add(stateFunction);
    super.initState();
  }

  @override
  void dispose() {
    contextStack.remove(this.context);
    writeLog("InfoPage::dispose()", Log.INFO);
    print(Events.setStates.remove(stateFunction));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFF9FBFF),
        body: Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Icon(
                          null,
                          size: 30,
                          color: Color(0xff02457a),
                        ),
                      ),
                      Text(
                        widget.device.deviceName,
                        style: TextStyle(
                          fontSize: 30,
                          color: Color(0xff02457a),
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          options(widget.device);
                        },
                        child: Icon(
                          Icons.menu,
                          size: 30,
                          color: Color(0xff02457a),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1), //color of shadow
                          spreadRadius: 5, //spread radius
                          blurRadius: 7, // blur radius
                          offset: Offset(0, 2),
                        )
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Air Purification",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Color(0xff02457a),
                                  // fontWeight: FontWeight.bold,
                                )),
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            child: RiveAnimation.asset(
                              'assets/spinner.riv',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DevicePage(widget.device)));
                    },
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.grey.withOpacity(0.1), //color of shadow
                            spreadRadius: 5, //spread radius
                            blurRadius: 7, // blur radius
                            offset: Offset(0, 2),
                          )
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Surface Disinfection",
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Color(0xff02457a),
                                    // fontWeight: FontWeight.bold,
                                  )),
                            ),
                            Container(
                              width: 50,
                              height: 50,
                              child: Icon(
                                widget.device.isStopped
                                    ? Icons.light_mode_outlined
                                    : Icons.light_mode_rounded,
                                size: 30,
                                color: Color(0xff02457a),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xff99cadc),
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                            child: Text("Important",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Color(0xff02457a))),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.orange[500],
                              size: 40,
                            ),
                            title: Text(
                              "Exposure to UVC radiation causes eyes & skin irritation",
                              style: TextStyle(
                                  fontSize: 18, color: Color(0xff02457a)),
                            ),
                          ),
                          ListTile(
                              leading: Icon(
                                Icons.menu_rounded,
                                color: Color(0xff02457a),
                                size: 30,
                              ),
                              title: Text(
                                "Replace Hepa filter every 3-6 months",
                                style: TextStyle(
                                    fontSize: 18, color: Color(0xff02457a)),
                              )),
                          ListTile(
                              leading: Icon(
                                Icons.menu_rounded,
                                color: Color(0xff02457a),
                                size: 30,
                              ),
                              title: Text(
                                "Inner UVC tube lifespan - 9000Hrs",
                                style: TextStyle(
                                    fontSize: 18, color: Color(0xff02457a)),
                              )),
                          ListTile(
                              leading: Icon(
                                Icons.menu_rounded,
                                color: Color(0xff02457a),
                                size: 30,
                              ),
                              title: Text(
                                "Outer UVC tubes lifespan - 9000Hrs",
                                style: TextStyle(
                                    fontSize: 18, color: Color(0xff02457a)),
                              )),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     Column(
                          //       children: [
                          //         Icon(
                          //           Icons.lightbulb_outline_rounded,
                          //           size: 50,
                          //           color: Colors.green,
                          //         ),
                          //         Text("Good",
                          //             style: TextStyle(
                          //                 fontSize: 16, color: Colors.green[800]))
                          //       ],
                          //     ),
                          //     Column(
                          //       children: [
                          //         Icon(
                          //           Icons.lightbulb_outline_rounded,
                          //           size: 50,
                          //           color: Colors.orange,
                          //         ),
                          //         Text("Moderate",
                          //             style: TextStyle(
                          //                 fontSize: 16,
                          //                 color: Colors.orange[800]))
                          //       ],
                          //     ),
                          //     Column(
                          //       children: [
                          //         Icon(
                          //           Icons.lightbulb_outline_rounded,
                          //           size: 50,
                          //           color: Colors.red,
                          //         ),
                          //         Text(
                          //           "Unhealthy",
                          //           style: TextStyle(
                          //               fontSize: 16, color: Colors.red[800]),
                          //         )
                          //       ],
                          //     )
                          //   ],
                          // )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.restart_alt_rounded,
                          color: Color(0xff00477d),
                        ),
                        title: Text('Restart Device',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w300)),
                        onTap: () async {
                          writeLog("InfoPage::onTapRestart()", Log.INFO);
                          device.sendMessage("65");
                          setState(() {
                            device.stopTimer(send: false);
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red[200],
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.stop_circle_outlined,
                          color: Colors.red,
                        ),
                        title: Text('Emergency Stop',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w300)),
                        onTap: () async {
                          writeLog("InfoPage::onTapEmergencyStop()", Log.INFO);
                          setState(() {
                            device.stopTimer();
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ],
          );
        });
  }
}
