import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  AppBarWidget();
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: new IconButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.arrow_back),
        color: Colors.blue,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
