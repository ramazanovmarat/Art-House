import 'dart:ui';

import 'draw_point.dart';

class DrawLine {
  final List<DrawPoint> points;
  final Color color;
  final double width;
  final bool isEraser;

  DrawLine({
    required this.points,
    required this.color,
    required this.width,
    this.isEraser = false,
  });
}