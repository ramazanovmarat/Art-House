import 'package:art_house/src/features/editor/domain/draw_line.dart';
import 'package:flutter/material.dart';

class CanvasPainter extends CustomPainter {
  CanvasPainter({
    required List<DrawLine> lines,
    DrawLine? activeLine,
  })  : _lines = lines,
        _activeLine = activeLine;

  final List<DrawLine> _lines;
  final DrawLine? _activeLine;

  @override
  void paint(Canvas canvas, Size size) {
    // Используем отдельный слой, так как поддерживаем режим ластика
    // (BlendMode.clear некорректно работает без saveLayer)
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    for (final line in _lines) {
      _renderStroke(canvas, line);
    }

    // Текущая линия может быть null, если пользователь не рисует
    final active = _activeLine;
    if (active != null) {
      _renderStroke(canvas, active);
    }

    // Restore нужен чтобы canvas вернулся в исходное состояние и ластик работал коректно
    canvas.restore();
  }

  void _renderStroke(Canvas canvas, DrawLine line) {

    final paint = Paint()
      ..color = line.isEraser ? Colors.transparent : line.color
      ..strokeWidth = line.width
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..blendMode = line.isEraser ? BlendMode.clear : BlendMode.srcOver;

    Path path = Path();
    if (line.points.isNotEmpty) {

      path.moveTo(
        line.points.first.offset.dx,
        line.points.first.offset.dy,
      );

      for (var i = 1; i < line.points.length; i++) {
        path.lineTo(
          line.points[i].offset.dx,
          line.points[i].offset.dy,
        );
      }

    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CanvasPainter oldDelegate) {
    // Перерисовываем только если изменились линии или активный stroke
    return oldDelegate._lines != _lines ||
        oldDelegate._activeLine != _activeLine;
  }
}