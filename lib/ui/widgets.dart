import 'package:BubbleO/model/Device.dart';
import 'package:flutter/material.dart';

BuildContext get context => contextStack.last;
List<BuildContext> contextStack = [];

Widget genericTile(
    {required IconData leadingIcon,
    required String text,
    Widget? subTitle,
    required Widget trailing,
    required void Function() onTap,
    required void Function() onLongPress,
    Color? color}) {
  return Container(
    decoration: BoxDecoration(
      color: color != null ? color : Colors.grey[100],
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
    ),
    margin: EdgeInsets.all(10),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        onLongPress: onLongPress,
        leading: Icon(
          leadingIcon,
          color: Color(0xff00477d),
        ),
        title: Text(text),
        subtitle: subTitle != null ? subTitle : null,
        trailing: Container(
          width: 60,
          height: 60,
          child: trailing,
        ),
        onTap: onTap,
      ),
    ),
  );
}

motionDetectedPopUp(Device device) async {
  device.stopTimer(send: false);
  device.statusText = "Ready to Disinfect";
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return SimpleDialog(
        backgroundColor: Color(0xffe8e8e8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Motion Detected',
          textAlign: TextAlign.center,
        ),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.warning_rounded, color: Colors.redAccent),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Your device has been stopped"),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Color(0xff02457a),
                  child: Text(
                    "Ok",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
          )
        ],
      );
    },
  );
}

renameDevicePopUp(Device device) async {
  TextEditingController nameController = TextEditingController();
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (contextPopUp) {
      contextStack.add(contextPopUp);
      return SimpleDialog(
        backgroundColor: Color(0xffe8e8e8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Rename Device',
          textAlign: TextAlign.center,
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
            child: TextField(
              cursorColor: Colors.black,
              decoration: InputDecoration(
                labelText: "Name your Device",
                focusColor: Colors.black,
                labelStyle: TextStyle(color: Colors.black),
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Colors.black,
                    style: BorderStyle.solid,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Colors.black,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              controller: nameController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Color(0xff00477d),
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    device.rename(nameController.text);
                    Navigator.pop(contextStack.removeLast());
                  }),
            ),
          )
        ],
      );
    },
  );
  if (contextStack.last.widget.runtimeType == Builder)
    contextStack.removeLast();
}
