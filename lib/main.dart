//===================================================================
// File: main.dart
//
// Desc: Main entry point for application.
//
// Copyright © 2019 Edwin Cloud. All rights reserved.
//
// * Attribution to Tensor and his channel on YouTube at      *
// * https://www.youtube.com/channel/UCYqCZOwHbnPwyjawKfE21wg *
//===================================================================

import 'package:flutter/material.dart';
import 'dart:math' show pi;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> with TickerProviderStateMixin {
  AnimationController controller;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return "${duration.inMinutes}: ${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        canvasColor: Color.fromRGBO(30, 30, 30, 1.0),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        accentColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Align(
                  alignment: FractionalOffset.center,
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: AnimatedBuilder(
                            animation: controller,
                            builder: (BuildContext ctx, Widget child) {
                              return CustomPaint(
                                painter: TimerPainter(
                                  animation: controller,
                                  backgroundColor: Colors.white,
                                  color: Theme.of(context).indicatorColor,
                                ),
                              );
                            },
                          ),
                        ),
                        Align(
                          alignment: FractionalOffset.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Count Down",
                                style: Theme.of(context)
                                    .textTheme
                                    .subhead
                                    .apply(color: Colors.white),
                              ),
                              AnimatedBuilder(
                                animation: controller,
                                builder: (BuildContext ctx, Widget child) {
                                  return GestureDetector(
                                    onTap: () {
                                      print("hello");
                                    },
                                    child: Text(
                                      timerString,
                                      style: Theme.of(context)
                                          .textTheme
                                          .display4
                                          .apply(color: Colors.white),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FloatingActionButton(
                      child: AnimatedBuilder(
                        animation: controller,
                        builder: (BuildContext ctx, Widget child) {
                          return Icon(controller.isAnimating
                              ? Icons.pause
                              : Icons.play_arrow);
                        },
                      ),
                      onPressed: () {
                        if (controller.isAnimating) {
                          controller.stop();
                        } else {
                          controller.reverse(
                              from: controller.value == 0.0
                                  ? 1.0
                                  : controller.value);
                        }
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TimerPainter extends CustomPainter {
  // class variables
  final Animation<double> animation;
  final Color backgroundColor, color;

  // constructor
  TimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * pi;
    canvas.drawArc(Offset.zero & size, pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter oldDelegate) {
    return animation.value != oldDelegate.animation.value ||
        color != oldDelegate.color ||
        backgroundColor != oldDelegate.backgroundColor;
  }
}
