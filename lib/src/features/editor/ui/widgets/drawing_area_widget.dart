import 'package:art_house/src/features/editor/ui/canvas/canvas_painter.dart';
import 'package:art_house/src/features/editor/ui/controllers/editor_controller.dart';
import 'package:art_house/src/features/editor/ui/controllers/editor_state.dart';
import 'package:flutter/material.dart';

class DrawingAreaWidget extends StatelessWidget {
  final GlobalKey globalKey;
  final EditorState editorState;
  final EditorController editorController;
  const DrawingAreaWidget({
    super.key,
    required this.globalKey,
    required this.editorState,
    required this.editorController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 21, right: 21),
      child: RepaintBoundary(
        key: globalKey,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: Colors.white,
            child: Stack(
              fit: StackFit.expand,
              children: [

                if (editorState.backgroundImage != null)
                  Image.memory(
                    editorState.backgroundImage!,
                    fit: BoxFit.cover,
                  ),

                LayoutBuilder(
                  builder: (context, constraints) {
                    return GestureDetector(

                      onPanStart: (details) {
                        final RenderBox renderBox = context.findRenderObject() as RenderBox;
                        final offset = renderBox.globalToLocal(details.globalPosition);
                        editorController.startLine(offset);
                      },

                      onPanUpdate: (details) {
                        final RenderBox renderBox = context.findRenderObject() as RenderBox;
                        final offset = renderBox.globalToLocal(details.globalPosition);
                        editorController.updateLine(offset);
                      },

                      onPanEnd: (_) {
                        editorController.endLine();
                      },

                      child: CustomPaint(
                        size: Size(constraints.maxWidth, constraints.maxHeight),
                        painter: CanvasPainter(
                          lines: editorState.lines,
                          activeLine: editorState.activeLine,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
