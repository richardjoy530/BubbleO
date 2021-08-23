import 'package:BubbleO/model/Device.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class DevicePage extends StatefulWidget {
  final Device device;

  const DevicePage(this.device, {Key? key}) : super(key: key);

  @override
  _DevicePageState createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  // final selectorColor = CustomSliderColors(
  //   dotColor: Color(0xff02457a),
  //   progressBarColor: Color(0xffd6e7ee),
  //   hideShadow: true,
  //   trackColor: Colors.lightBlue[50],
  //   progressBarColors: [
  //     Color(0xff00477d),
  //     Color(0xff008bc0),
  //     Color(0xff97cadb),
  //   ],
  // );

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          widget.device.deviceName,
          style: TextStyle(
            fontSize: 30,
            color: Color(0xff02457a),
            // fontWeight: FontWeight.bold,
          ),
        ),
        SleekCircularSlider(
          min: 0,
          max: 21,
          initialValue: 0,
          appearance: CircularSliderAppearance(
              animationEnabled: false,
              startAngle: 270 + 45,
              angleRange: 270,
              customWidths: CustomSliderWidths(
                handlerSize: 20,
                trackWidth: 5,
                progressBarWidth: 20,
              ),
              size: (MediaQuery.of(context).size.width / 1.5) + 50,
              customColors: customColor),
          onChange: (double value) {
            // TODO
          },
          innerWidget: (value) {
            return Center(
              child: widget.device.isStopped
                  ? Text(
                      '${getSeconds(mapValues(value.round()))}'
                      ':00',
                      style: TextStyle(fontSize: 40),
                    )
                  : Text(
                      '${getMinuets(widget.device.getRemainingTime().inSeconds)}'
                      ':${getSeconds(widget.device.getRemainingTime().inSeconds)}',
                      style: TextStyle(fontSize: 40),
                    ),
              // child: Text(
              //   '${getMinuets(((widget.device.getRemainingTime().inSeconds)))}'
              //   ':${getSeconds(((widget.device.getRemainingTime().inSeconds)))}',
              //   style: TextStyle(fontSize: 40),
              // ),
            );
          },
        ),
        Container(
          // height: 100,
          child: widget.device.isStopped
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        widget.device.startTimer(() {}); //TODO
                      },
                      child: Container(
                        width: 150,
                        height: 70,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff00477d),
                              Color(0xff008bc0),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(5, 5),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Start',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        widget.device.stopTimer();
                      },
                      child: Container(
                        width: 100,
                        height: 70,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff00477d),
                              Color(0xff008bc0),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(5, 5),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Stop',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.device.isPaused
                            ? widget.device.playTimer()
                            : widget.device.pauseTimer();
                      },
                      child: Container(
                        width: 100,
                        height: 70,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff00477d),
                              Color(0xff008bc0),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(5, 5),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.device.isPaused ? 'Play' : 'Pause',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        )
      ],
    )));
  }

  getSeconds(int seconds) {
    var f = new NumberFormat("00", "en_US");
    return f.format(seconds % 60);
  }

  getMinuets(int seconds) {
    var f = new NumberFormat("00", "en_US");
    return f.format(
      (seconds / 60).floor(),
    );
  }

  int mapValues(int value) {
    var temp = 0;
    if (value == 0) {
      temp = 0;
    } else if (value == 1) {
      temp = 1;
    } else if (value == 2) {
      temp = 2;
    } else if (value == 3) {
      temp = 3;
    } else if (value == 4) {
      temp = 4;
    } else if (value == 5) {
      temp = 5;
    } else if (value == 6) {
      temp = 6;
    } else if (value == 7) {
      temp = 7;
    } else if (value == 8) {
      temp = 8;
    } else if (value == 9) {
      temp = 9;
    } else if (value == 10) {
      temp = 10;
    } else if (value == 11) {
      temp = 15;
    } else if (value == 12) {
      temp = 20;
    } else if (value == 13) {
      temp = 25;
    } else if (value == 14) {
      temp = 30;
    } else if (value == 15) {
      temp = 35;
    } else if (value == 16) {
      temp = 40;
    } else if (value == 17) {
      temp = 45;
    } else if (value == 18) {
      temp = 50;
    } else if (value == 19) {
      temp = 55;
    } else if (value == 20) {
      temp = 59;
    } else if (value == 21) {
      temp = 59;
    }
    return temp;
  }
}
