import 'package:flutter/material.dart';

Widget genericTile(
    {required IconData leadingIcon,
    required String text,
    Widget? subTitle,
    required Widget trailing,
    required void Function() onTap,
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
        leading: Icon(
          leadingIcon,
          color: Colors.black,
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
