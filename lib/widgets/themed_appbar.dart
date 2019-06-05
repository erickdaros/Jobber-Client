import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ThemedAppBar extends StatelessWidget implements PreferredSizeWidget {

  final AppBar appBar;
  final ThemeData themeData;

  const ThemedAppBar({Key key, this.themeData, this.appBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Theme(
      data: themeData,
      child: appBar
    );
  }

  // TODO: implementar preferredSize
  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}