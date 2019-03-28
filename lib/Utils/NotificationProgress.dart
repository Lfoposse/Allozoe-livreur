import 'dart:math';
import 'dart:ui';

import 'package:allozoe_livreur/Models/Commande.dart';
import 'package:flutter/material.dart';

class NotificationProgress extends StatefulWidget {
  Commande cmd;
  NotificationProgress(this.cmd);
  @override
  _NotificationProgressState createState() => _NotificationProgressState();
}

class _NotificationProgressState extends State<NotificationProgress>
    with TickerProviderStateMixin {
  double percentage = 0.0;
  double newPercentage = 0.0;
  AnimationController percentageAnimationController;

  @override
  void initState() {
    super.initState();
    setState(() {
      percentage = 0.0;
      percentageAnimationController = new AnimationController(
          vsync: this, duration: new Duration(seconds: 30))
        ..addListener(() {
          setState(() {
            percentage = percentage + percentageAnimationController.value * 0.5;
          });
        });
      percentageAnimationController.forward(from: 0.0);
    });
  }

  @override
  void dispose() {
    // ignore: undefined_getter
    percentageAnimationController.dispose();
    print("progress dismiss");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Container(
        margin: EdgeInsets.only(top: 0.0),
        decoration: new BoxDecoration(
          border: new Border.all(
              color: Color(0xFF91b411).withOpacity(0.7),
              style: BorderStyle.solid,
              width: 6.0),
          shape: BoxShape.circle,
        ),
        height: 80.0,
        width: 80.0,
        //  mainAxisAlignment: MainAxisAlignment.start,
        alignment: Alignment.bottomCenter,
        child: new CustomPaint(
          foregroundPainter: new MyPainter(
              lineColor: Color(0xFF91b411).withOpacity(0.7),
              completeColor: Color(0xFFb1fe07),
              completePercent: percentage,
              width: 4.0),
          child: new Padding(
            padding: const EdgeInsets.all(2.0),
            child: Stack(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    decoration: new BoxDecoration(
                      border: new Border.all(
                          color: Color(0xFF91b411).withOpacity(0.8),
                          style: BorderStyle.solid,
                          width: 6.0),
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('images/map.png'),
                      ),
                    )),
                Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 35.0),
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: AssetImage('images/location.png'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    //color: Colors.white,
                    // child: Text("qdqndjqnsdnqndq"),
                    )
                /*    RaisedButton(
                color: Colors.purple,
                splashColor: Colors.blueAccent,
                shape: new CircleBorder(),
                child: new Image.network(""),
                onPressed: () {
                  setState(() {
                    percentage = newPercentage;
                    newPercentage += 10;
                    if (newPercentage > 100.0) {
                      percentage = 0.0;
                      newPercentage = 0.0;
                    }
                    percentageAnimationController.forward(from: 0.0);
                  });
                }),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  Color lineColor;
  Color completeColor;
  double completePercent;
  double width;
  MyPainter(
      {this.lineColor, this.completeColor, this.completePercent, this.width});
  @override
  void paint(Canvas canvas, Size size) {
    Paint line = new Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Paint complete = new Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, line);

    double arcAngle = 2 * pi * (completePercent / 400);

    canvas.drawArc(new Rect.fromCircle(center: center, radius: radius), -pi / 2,
        arcAngle, false, complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
