import 'package:flutter/material.dart';

class ResponsiveSizedBox extends StatelessWidget {
  final double heightRatio;
  final double widthRatio;
  ResponsiveSizedBox({
    this.heightRatio = 0.0,
    this.widthRatio = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SizedBox(
      height: mediaQuery.size.height * heightRatio,
      width: mediaQuery.size.width * widthRatio,
    );
  }
}
