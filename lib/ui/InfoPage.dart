import 'package:BubbleO/model/Device.dart';
import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  final Device device;

  const InfoPage(this.device, {Key? key}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
                child: Column())));
  }
}
