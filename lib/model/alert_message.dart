import 'package:flutter/material.dart';

Widget showAlertDialog(
    {required BuildContext context,
    required VoidCallback onPressFunction,
    required String? message}) {
  Widget okButton = TextButton(
    child: Text('OK'),
    onPressed: () {
      Navigator.pop(context);
      onPressFunction();
    },
  );

  var alert = AlertDialog(
    content: Text('$message'),
    actions: [
      okButton,
    ],
  );
  return alert;
}
