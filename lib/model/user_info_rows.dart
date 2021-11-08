import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget userInfo(double a, String info) {
  return Row(children: [
    Padding(
      padding: EdgeInsets.only(left: 20, top: a, right: 20),
      child: Text(
        '$info',
        style: TextStyle(fontSize: 14, color: Colors.black),
      ),
    ),
  ]);
}
