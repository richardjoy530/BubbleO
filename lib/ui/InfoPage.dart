import 'package:BubbleO/Events/TriggerFunctions.dart';
import 'package:BubbleO/model/Device.dart';
import 'package:BubbleO/ui/DevicePage.dart';
import 'package:BubbleO/ui/widgets.dart';
import 'package:BubbleO/utils/Logger.dart';
import 'package:badges/badges.dart';
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
            padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 70,
                        width: MediaQuery.of(context).size.width * 6.5 / 8,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.1), //color of shadow
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DevicePage(widget.device)));
                        },
                        child: Container(
                          height: 70,
                          width: MediaQuery.of(context).size.width * 6.5 / 8,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.1), //color of shadow
                                spreadRadius: 5, //spread radius
                                blurRadius: 7, // blur radius
                                offset: Offset(0, 2),
                              )
                            ],
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
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
                      Badge(
                        toAnimate: false,
                        showBadge: false,
                        position: BadgePosition.topStart(),
                        badgeColor: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                        badgeContent: Text("1"),
                        child: Icon(
                          Icons.notifications_none_rounded,
                          size: 30,
                          color: Color(0xff02457a),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SleekCircularSlider(
                        initialValue: 80,
                        appearance: CircularSliderAppearance(
                            size: 170,
                            customWidths: CustomSliderWidths(
                              handlerSize: 0,
                              trackWidth: 2,
                            ),
                            customColors: customColor),
                      ),
                      Text("Hepa Filter",
                          style: TextStyle(
                            fontSize: 24,
                            color: Color(0xff02457a),
                            // fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Purifier UVC",
                          style: TextStyle(
                            fontSize: 24,
                            color: Color(0xff02457a),
                            // fontWeight: FontWeight.bold,
                          )),
                      SleekCircularSlider(
                        initialValue: 90,
                        appearance: CircularSliderAppearance(
                            size: 170,
                            customWidths: CustomSliderWidths(
                              handlerSize: 0,
                              trackWidth: 2,
                            ),
                            customColors: customColor),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SleekCircularSlider(
                        initialValue: 95,
                        appearance: CircularSliderAppearance(
                            size: 170,
                            customWidths: CustomSliderWidths(
                              handlerSize: 0,
                              trackWidth: 2,
                            ),
                            customColors: customColor),
                      ),
                      Text("Disinfection UVC",
                          style: TextStyle(
                            fontSize: 24,
                            color: Color(0xff02457a),
                            // fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                ),
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
                  ListTile(
                    leading: Icon(
                      Icons.restart_alt_rounded,
                    ),
                    title: Text('Restart Device',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300)),
                    onTap: () async {
                      Navigator.pop(context);
                      writeLog("InfoPage::onTapRestart()", Log.INFO);
                      device.sendMessage("65");
                      device.bluetoothConnection?.close();
                      setState(() {
                        device.stopTimer(send: false);
                      });
                      setState(() {});
                    },
                  )
                ],
              ),
            ],
          );
        });
  }
}
