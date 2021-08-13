import 'package:BubbleO/ui/RegisterPage.dart';
import 'package:BubbleO/ui/widgets.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
                icon: Icon(Icons.menu_rounded),
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
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return genericTile(
                            text: "Living Room",
                            subTitle: LinearPercentIndicator(
                              lineHeight: 5.0,
                              percent: 0.9,
                              progressColor: Colors.black,
                            ),
                            color: Colors.white,
                            leadingIcon: Icons.wifi_tethering_rounded,
                            trailing: Icon(Icons.arrow_forward_ios_rounded),
                            onTap: () {});
                      })),
            ),
          )
        ],
      ),
    ));
  }

  onMenuPressed() {
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
                      Icons.add,
                    ),
                    title: Text('Add New Device',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()));
                    },
                  ),
                ],
              ),
            ],
          );
        });
  }
}