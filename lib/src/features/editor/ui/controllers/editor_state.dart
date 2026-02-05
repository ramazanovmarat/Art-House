import 'dart:typed_data';
import 'package:art_house/src/features/editor/domain/draw_line.dart';
import 'package:flutter/material.dart';

// pen - режим рисования, а eraser - режим ластика
enum EditorMode {pen, eraser}

class EditorState {
  final List<DrawLine> lines;
  final DrawLine? activeLine;
  final Color selectedColor;
  final Uint8List? backgroundImage;
  final EditorMode mode;

  EditorState({
    this.lines = const [],
    this.activeLine,
    this.selectedColor = Colors.black,
    this.backgroundImage,
    this.mode = EditorMode.pen,
  });

  EditorState copyWith({
    List<DrawLine>? lines,
    DrawLine? activeLine,
    Color? selectedColor,
    Uint8List? backgroundImage,
    EditorMode? mode,
  }) {
    return EditorState(
      lines: lines ?? this.lines,
      activeLine: activeLine ?? this.activeLine,
      selectedColor: selectedColor ?? this.selectedColor,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      mode: mode ?? this.mode,
    );
  }
}