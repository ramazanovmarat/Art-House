import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PanelInstrumentButton extends StatelessWidget {
  final void Function()? onPressed;
  final String assetName;
  const PanelInstrumentButton({super.key, required this.onPressed, required this.assetName});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: Color(0xFF3A3A3F),
      ),
      icon: SvgPicture.asset(
        assetName,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    );
  }
}
