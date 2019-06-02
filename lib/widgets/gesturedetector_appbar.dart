import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GestureDetectorAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onTap;
  final AppBar appBar;
  final HitTestBehavior behavior;

  const GestureDetectorAppBar({Key key, this.onTap,this.behavior, this.appBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(onTap: onTap, behavior: behavior,child: appBar);
  }

  // TODO: implementar preferredSize
  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}