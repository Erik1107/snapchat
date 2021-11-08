import 'package:flutter/material.dart';

class UserButton extends StatelessWidget {
  UserButton(
      {required this.buttonText, required this.function, required this.color});
  final VoidCallback function;
  final String buttonText;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 20),
        child: TextButton(
          style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(Size(200, 30)),
              backgroundColor: MaterialStateProperty.all(color),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ))),
          onPressed: function,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              buttonText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
