import 'package:flutter/material.dart';

class EmptyFragment extends StatefulWidget {

  static String routeName = 'emptyView';
  static String title = 'Empty';

  @override
  State createState() => _EmptyFragmentState();
}

class _EmptyFragmentState extends State<EmptyFragment> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Text("Empty"),
    );
  }
}
