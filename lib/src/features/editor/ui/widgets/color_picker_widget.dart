import 'package:flutter/material.dart';

class ColorPickerWidget extends StatefulWidget {
  final Color selectedColor;
  final Function(Color) onColorChanged;

  const ColorPickerWidget({
    super.key,
    required this.selectedColor,
    required this.onColorChanged,
  });

  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  late final List<Color> _colors;

  @override
  void initState() {
    super.initState();
    _colors = _generateColorGrids();
  }

  // Логика генерации цветов
  List<Color> _generateColorGrids() {
    List<Color> colors = [];

    // Вверхний ряд генерируем от белого до черного
    for (int i = 0; i < 12; i++) {
      int value = (255 - (i * (255 / 11))).round();
      colors.add(Color.fromARGB(255, value, value, value));
    }

    // 2. Тут меняем оттенок цвета по горизонтали и насыщенность по вертикали
    const int rows = 9;
    const int columns = 12;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < columns; col++) {

        final double shade = ((col * (360 / columns)) + 200) % 360;

        const double saturation = 1.0;

        final double brightness = 0.15 + (row / (rows - 1)) * 0.75;

        colors.add(HSLColor.fromAHSL(1.0, shade, saturation, brightness).toColor());
      }
    }

    return colors;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 12,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
            ),
            itemCount: _colors.length,
            itemBuilder: (context, index) {
              final color = _colors[index];
              final isSelected = color.value == widget.selectedColor.value;

              return GestureDetector(
                onTap: () => widget.onColorChanged(color),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      color: color,
                    ),
                    if (isSelected)
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        width: 26,
                        height: 26,
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}