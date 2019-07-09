import 'package:flutter/material.dart';

class Back extends StatelessWidget {
  final Color color;

  Back({Key key, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Icon(
        Icons.navigate_before,
        color: color,
        size: 40,
      ),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }
}
