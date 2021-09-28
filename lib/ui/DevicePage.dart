import 'dart:math';

import 'package:BubbleO/Events/TriggerFunctions.dart';
import 'package:BubbleO/model/Device.dart';
import 'package:BubbleO/ui/widgets.dart';
import 'package:BubbleO/utils/Logger.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DevicePage extends StatefulWidget {
  final Device device;

  const DevicePage(this.device, {Key? key}) : super(key: key);

  @override
  _DevicePageState createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> with TickerProviderStateMixin {
  StateFunction stateFunction = () {};
  AnimationController? radialProgressAnimationController;
  late Animation<double> progressAnimation;
  double progressDegrees = 0;

  @override
  void initState() {
    contextStack.add(this.context);
    progressDegrees = 360 -
        ((widget.device.getRemainingTime().inSeconds /
                widget.device.getTotalDuration().inSeconds) *
            360);
    writeLog("DevicePage::initState()", Log.INFO);
    stateFunction = () {
      setState(() {});
    };
    Events.setStates.add(stateFunction);
    if (widget.device.isStopped == false) {
      runAnimation(
          begin: (360 / (widget.device.mainDuration.inMinutes * 60)) *
              widget.device.getElapsedTime().inSeconds,
          end: 360);

      if (widget.device.isPaused == false) {
        radialProgressAnimationController?.forward();
      }
    }
    updateStatus();
    super.initState();
  }

  @override
  void dispose() {
    contextStack.remove(this.context);
    writeLog("DevicePage::dispose()", Log.INFO);
    print(Events.setStates.remove(stateFunction));
    destroyAnimation();
    super.dispose();
  }

  void updateStatus() {
    setState(() {
      if (widget.device.isStopped)
        widget.device.statusText = "Ready to Disinfect";
      else if (widget.device.isPaused)
        widget.device.statusText = "Paused";
      else
        widget.device.statusText = "Disinfecting";
    });
  }

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
            body: Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    widget.device.bluetoothConnection != null &&
                            widget.device.bluetoothDevice.isBonded
                        ? Icons.bluetooth_connected_rounded
                        : Icons.bluetooth_rounded,
                    color: Color(0xff00477d),
                  )),
              Text(
                widget.device.deviceName,
                style: TextStyle(
                  fontSize: 30,
                  color: Color(0xff02457a),
                  // fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 30,
                  width: 30,
                  child: FlareActor(
                    'assets/status.flr',
                    animation: widget.device.isStopped == true &&
                            widget.device.isStopped == false
                        ? 'Connected'
                        : 'off',
                  ),
                ),
              ),
            ],
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  FlareActor(
                    'assets/breathing.flr',
                    animation:
                        !widget.device.isStopped && !widget.device.isPaused
                            ? 'off'
                            : 'breath',
                  ),
                  Container(
                      height: min(MediaQuery.of(context).size.height / 1.5,
                          MediaQuery.of(context).size.width / 1.5),
                      width: min(MediaQuery.of(context).size.height / 1.5,
                          MediaQuery.of(context).size.width / 1.5),
                      child: Center(
                        child: Container(
                          height:
                              (MediaQuery.of(context).size.width / 1.5) - 50,
                          width: (MediaQuery.of(context).size.width / 1.5) - 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                        ),
                      )),
                  SleekCircularSlider(
                    min: 0,
                    max: widget.device.isStopped ? 21 : 360,
                    initialValue:
                        widget.device.isStopped ? 0 : 360 - progressDegrees,
                    // : 360 -
                    //     ((widget.device.getRemainingTime().inSeconds /
                    //             widget.device.getTotalDuration().inSeconds) *
                    //         360),
                    appearance: CircularSliderAppearance(
                        animationEnabled: false,
                        startAngle: 270,
                        angleRange: 360,
                        customWidths: CustomSliderWidths(
                          handlerSize: widget.device.isStopped ? 20 : 0,
                          trackWidth: 5,
                          progressBarWidth: 20,
                        ),
                        size: (MediaQuery.of(context).size.width / 1.5) + 50,
                        customColors: customColor),
                    onChange: widget.device.isStopped
                        ? (double value) {
                            widget.device.setTimer(Duration(
                                minutes: mapValues(value.floor()) == 59
                                    ? 60
                                    : mapValues(value.floor())));
                          }
                        : null,
                    innerWidget: (value) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.device.statusText,
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                            ),
                            Visibility(
                              visible: !widget.device.isStopped &&
                                  !widget.device.isPaused,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AnimatedSmoothIndicator(
                                  activeIndex: ((progressDegrees / 3) % 3).isNaN
                                      ? 1
                                      : ((progressDegrees / 3) % 3).floor(),
                                  count: 3,
                                  effect: SlideEffect(
                                      dotColor: Color(0xffb8d3e8),
                                      activeDotColor: Color(0xff02457a)),
                                ),
                              ),
                            ),
                            widget.device.isStopped
                                ? Text(
                                    '${mapValues(value.floor()) == 59 ? 60 : getSeconds(mapValues(value.floor()))}'
                                    ':00',
                                    style: TextStyle(fontSize: 40),
                                  )
                                : Text(
                                    '${getMinuets(widget.device.getRemainingTime().inSeconds)}'
                                    ':${getSeconds(widget.device.getRemainingTime().inSeconds)}',
                                    style: TextStyle(fontSize: 40),
                                  ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            // height: 100,
            child: widget.device.isStopped
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          if (widget.device.mainDuration.inMinutes != 0 &&
                              widget.device.isStopped) {
                            writeLog("DevicePage::onTapStart()", Log.INFO);
                            widget.device.startTimer(() {}); //TODO
                            runAnimation();
                            radialProgressAnimationController?.forward();
                            updateStatus();
                          }
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
                          writeLog("DevicePage::onTapStop()", Log.INFO);
                          setState(() {
                            widget.device.stopTimer();
                            radialProgressAnimationController?.stop();
                            radialProgressAnimationController?.reset();
                          });
                          setState(() {
                            updateStatus();
                          });
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
                          writeLog("DevicePage::onTapPlayPause()", Log.INFO);
                          if (widget.device.isPaused) {
                            widget.device.playTimer();
                            radialProgressAnimationController?.forward();
                          } else {
                            widget.device.pauseTimer();
                            radialProgressAnimationController?.stop();
                          }
                          updateStatus();
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
      ),
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
    print(value);
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
      temp = 60;
    }
    return temp;
  }

  runAnimation({
    double begin = 0.0,
    double end = 360.0,
  }) {
    radialProgressAnimationController = AnimationController(
        vsync: this,
        duration:
            Duration(seconds: widget.device.getRemainingTime().inSeconds));

    progressAnimation = Tween(begin: begin, end: end).animate(
      CurvedAnimation(
          parent: radialProgressAnimationController!, curve: Curves.linear),
    )..addListener(() {
        setState(() {
          progressDegrees = progressAnimation.value;
          if (progressAnimation.isCompleted) {
            setState(() {
              widget.device.stopTimer(send: false);
              updateStatus();
            });
          }
        });
      });
  }

  destroyAnimation() {
    if (radialProgressAnimationController != null)
      radialProgressAnimationController?.dispose();
  }
}
