import 'package:BubbleO/model/data.dart';
import 'package:BubbleO/model/db_helper.dart';
import 'package:BubbleO/services/BluetoothService.dart';
import 'package:flutter/material.dart';

import 'HomePage.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Container(
            width: 50,
            child: Image.asset('images/icon.png'),
          ),
        ),
      ),
    );
  }

  load() async {
    await DataBaseHelper.initializeDatabase();
    devices = await DataBaseHelper.getAllDevices();
    await BluetoothService.scan();
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }
}
