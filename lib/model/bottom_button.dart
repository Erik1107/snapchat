import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  Button({
    required this.buttonText,
    required this.checkColor,
    required this.route,
  });
  final bool checkColor;

  final VoidCallback? route;

  final String buttonText;
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      alignment: Alignment.bottomCenter,
      child: TextButton(
        style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(Size(200, 30)),
            backgroundColor: checkColor
                ? MaterialStateProperty.all(Colors.blue)
                : MaterialStateProperty.all(Colors.grey),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ))),
        onPressed: route,
        child: FittedBox(
          fit: BoxFit.fill,
          child: Text(
            buttonText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    ));
  }
}
