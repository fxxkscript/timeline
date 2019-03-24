import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FollowBtn extends StatelessWidget {
  final bool isFollowed;
  final Function onPressed;

  FollowBtn({Key key, @required this.isFollowed, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    if (isFollowed) {
      return FlatButton(
        onPressed: () {
          onPressed(isFollowed);
        },
        child: Container(
          width: 90,
          height: 27,
          decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border.all(color: Theme.of(context).dividerColor, width: 0.5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
              child: Text(
            '已关注',
            style: TextStyle(
                fontSize: 12, color: Theme.of(context).primaryColorDark),
          )),
        ),
      );
    } else {
      return FlatButton(
        onPressed: () {
          onPressed(isFollowed);
        },
        child: Container(
          width: 90,
          height: 27,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
              child: Text(
            '关注',
            style: TextStyle(fontSize: 12, color: Colors.white),
          )),
        ),
      );
    }
  }
}
