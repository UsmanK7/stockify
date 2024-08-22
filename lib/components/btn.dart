import 'package:flutter/material.dart';

class AppBtn extends StatelessWidget {
  final VoidCallback? onTap; 
  final Color color;
  final double width;
  final double height;
  final String title;
  const AppBtn({
    super.key,
    this.onTap,
    required this.width,
    required this.height,
    required this.color,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(4)),
        child: Center(
            child: Text(
          title,
          style: TextStyle(color: Colors.white),
        )),
      ),
    );
  }
}
