import 'package:flutter/material.dart';

class NotificationsFragment extends StatefulWidget {

  static String routeName = 'notificationsView';
  static String title = 'Avisos';

  @override
  State createState() => _NotificationsFragmentState();
}

class _NotificationsFragmentState extends State<NotificationsFragment> {

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
      child: Text("Sem avisos."),
    );
  }
}
