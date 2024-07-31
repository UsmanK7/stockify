import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String title;
  final Color color;
  final double font_size;
  final FontWeight fontWeight;
  const AppText(
      {super.key,
      required this.title,
      required this.color,
      required this.font_size,
      required this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: color,
        fontSize: font_size,
        fontWeight: fontWeight,
      ),
    );
  }
}
