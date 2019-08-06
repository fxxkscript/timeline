import 'package:flutter/material.dart';

class Back extends StatelessWidget {
  final Color color;
  final Function onTap;

  Back({Key key, this.color = Colors.white, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Icon(
        Icons.navigate_before,
        color: color,
        size: 40,
      ),
      onTap: () {
        if (this.onTap != null) {
          this.onTap();
        } else {
          Navigator.of(context).pop();
        }
      },
    );
  }
}
