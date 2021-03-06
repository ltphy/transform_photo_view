import 'package:flutter/material.dart';

class MapCanvas extends CustomPainter {
  final Offset topLeft;
  final Offset bottomRight;
  Paint mapPaint = Paint()
    ..color = Colors.yellow
    ..strokeWidth = 3
    ..style = PaintingStyle.fill
    ..strokeCap = StrokeCap.round;
  Paint topLeftPaint = Paint()
    ..color = Colors.green
    ..strokeWidth = 3
    ..style = PaintingStyle.fill
    ..strokeCap = StrokeCap.round;
  Paint pointPaint = Paint()
    ..color = Colors.red
    ..strokeWidth = 3
    ..style = PaintingStyle.fill
    ..strokeCap = StrokeCap.round;
  MapCanvas({this.topLeft = Offset.zero, this.bottomRight = Offset.zero});

  @override
  void paint(Canvas canvas, Size size) {
    print('draw color');
    canvas.drawRect(Rect.fromLTRB(0, 0, 500, 500), mapPaint);

    canvas.drawCircle(topLeft, 20, mapPaint);
    canvas.drawCircle(bottomRight, 20, mapPaint);
    canvas.drawCircle(Offset.zero, 2, pointPaint);
    canvas.drawCircle(Offset(163.1, 390.0), 5, pointPaint);
    canvas.drawCircle(Offset(-200.8, -279.0), 5, pointPaint);
  }

  @override
  bool shouldRepaint(MapCanvas mapCanvas) {
    return mapCanvas.topLeft != topLeft || mapCanvas.bottomRight != bottomRight;
  }
}
