import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController controller;
  double listViewOffset=0.0;

  @override
  void initState() {
    super.initState();
    controller = new TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tabs = <Tab>[
      new Tab(text: 'Tab 1'),
      new Tab(text: 'Tab 2')
    ];

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        bottom: new TabBar(controller: controller, tabs: tabs),
      ),
      body: new TabBarView(
          controller: controller,
          children: <Widget>[
            new StatefulListView(
//              getOffsetMethod: () => listViewOffset,
//              setOffsetMethod: (offset) => this.listViewOffset = offset,
            ),
            new Center(child: new Text('Tab 2'))
          ]),
    );
  }
}

class StatefulListView extends StatefulWidget {
  StatefulListView({Key key,}) : super(key: key);

//  final GetOffsetMethod getOffsetMethod;
//  final SetOffsetMethod setOffsetMethod;

  @override
  _StatefulListViewState createState() => new _StatefulListViewState();
}

class _StatefulListViewState extends State<StatefulListView> {

  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = new ScrollController(
//        initialScrollOffset: widget.getOffsetMethod()
    );
  }

  @override
  Widget build(BuildContext context) {
    return new NotificationListener(
      child: new ListView.builder(
        controller: scrollController,
        itemCount: 50,
        itemBuilder: (BuildContext context, int index) {
          return new Text("Data "+index.toString());
        },
      ),
      onNotification: (notification) {
        if (notification is ScrollNotification) {
//          widget.setOffsetMethod(notification.metrics.pixels);
        }
      },
    );
  }
}