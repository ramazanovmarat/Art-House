import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final bool? isGradient;
  final GestureTapCallback onTap;
  const CustomButton({super.key, required this.title, this.isGradient = true, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isGradient == true ? null : Colors.white,
          gradient: isGradient == true
              ? LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [
              const Color.fromRGBO(137, 36, 231, 1),
              const Color.fromRGBO(106, 70, 249, 1),
            ],
          ) : null,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isGradient == true ? Colors.white : Colors.black,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }
}
