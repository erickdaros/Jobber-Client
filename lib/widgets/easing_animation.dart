import 'package:flutter/material.dart';

class EasingAnimation extends StatefulWidget {
  final Widget child;
  final bool animate;
  EasingAnimation({
    Key key,
    this.child,
    this.animate = true,
  });
  @override
  EasingAnimationState createState() => EasingAnimationState();
}

class EasingAnimationState extends State<EasingAnimation>
    with TickerProviderStateMixin {

  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();
      _controller =
          AnimationController(vsync: this, duration: Duration(seconds: 1));
      _animation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ))..addStatusListener(handler);
  }
  void handler(status) {
    if (status == AnimationStatus.completed) {
      _animation.removeStatusListener(handler);
      _controller.reset();
      _animation = Tween(begin: 0.0, end: 0.0).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ));
//        ..addStatusListener((status) {
//          if (status == AnimationStatus.completed) {
//          Navigator.pop(context);
//          _animation.removeStatusListener(handler);
//          _controller.reset();
//          _animation = Tween(begin: 0.0, end: 0.0).animate(CurvedAnimation(
//            parent: _controller,
//            curve: Curves.fastOutSlowIn,
//          ))..addStatusListener(handler);
//          _controller.forward();
//          }
//        });
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    final double height = MediaQuery.of(context).size.height;
    return AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget child) {
          return Scaffold(
              body: Transform(
                transform:
                Matrix4.translationValues(0.0, _animation.value * height, 0.0),
                child: widget.child,
              ));
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}