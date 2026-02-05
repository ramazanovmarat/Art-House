import 'dart:typed_data';
import 'package:art_house/src/features/editor/domain/draw_line.dart';
import 'package:art_house/src/features/editor/domain/draw_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'editor_state.dart';

final editorControllerProvider = StateNotifierProvider.autoDispose<EditorController, EditorState>((ref) {
  return EditorController();
});

class EditorController extends StateNotifier<EditorState> {
  EditorController() : super(EditorState());

  void startLine(Offset offset) {

    final color = state.mode == EditorMode.eraser ? Colors.transparent : state.selectedColor;
    final width = state.mode == EditorMode.eraser ? 20.0 : 5.0;

    final point = DrawPoint(
      offset: offset,
      paint: Paint()..color = color..strokeWidth = width,
    );

    state = state.copyWith(
        activeLine: DrawLine(
          points: [point],
          color: color,
          width: width,
          isEraser: state.mode == EditorMode.eraser,
        ),
    );
  }

  void updateLine(Offset offset) {
    final currentPoints = List<DrawPoint>.from(state.activeLine?.points ?? []);
    final color = state.mode == EditorMode.eraser ? Colors.transparent : state.selectedColor;
    final width = state.mode == EditorMode.eraser ? 20.0 : 5.0;

    currentPoints.add(DrawPoint(
      offset: offset,
      paint: Paint()..color = color..strokeWidth = width,
    ));



    state = state.copyWith(
      activeLine: DrawLine(
        points: currentPoints,
        color: state.activeLine!.color,
        width: state.activeLine!.width,
        isEraser: state.mode == EditorMode.eraser,
      ),
    );
  }

  void endLine() {
    if (state.activeLine != null) {
      final newLines = List<DrawLine>.from(state.lines)..add(state.activeLine!);
      state = state.copyWith(lines: newLines, activeLine: null);
    }
  }

  void penMode() => state = state.copyWith(mode: EditorMode.pen);

  void eraserMode() => state = state.copyWith(mode: EditorMode.eraser);

  void colorPick(Color color) => state = state.copyWith(selectedColor: color, mode: EditorMode.pen);

  void backgroundImage(Uint8List imageBytes) {
    state = state.copyWith(backgroundImage: imageBytes, lines: []);
  }

}