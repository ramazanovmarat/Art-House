import 'package:art_house/src/features/editor/ui/widgets/panel_instrument_button.dart';
import 'package:flutter/material.dart';

class PanelInstrumentWidget extends StatelessWidget {
  final void Function() saveImage;
  final void Function() pickImage;
  final void Function() penMode;
  final void Function() eraserMode;
  final void Function() openColorPicker;
  const PanelInstrumentWidget({
    super.key,
    required this.saveImage,
    required this.pickImage,
    required this.penMode,
    required this.eraserMode,
    required this.openColorPicker,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 21, top: 24, bottom: 24),
      child: Row(
        spacing: 12,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          PanelInstrumentButton(
            onPressed: saveImage,
            assetName: 'assets/download.svg',
          ),

          PanelInstrumentButton(
            onPressed: pickImage,
            assetName: 'assets/gallery.svg',
          ),

          PanelInstrumentButton(
            onPressed: penMode,
            assetName: 'assets/pen.svg',
          ),

          PanelInstrumentButton(
            onPressed: eraserMode,
            assetName: 'assets/eraser.svg',
          ),

          PanelInstrumentButton(
            onPressed: openColorPicker,
            assetName: 'assets/pallete.svg',
          ),

        ],
      ),
    );
  }
}
