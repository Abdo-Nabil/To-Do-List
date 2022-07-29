import 'package:flutter/material.dart';

class BuildContactRow extends StatelessWidget {
  final String text;
  final String imageSource;
  final Function onTap;

  const BuildContactRow({
    required this.text,
    required this.imageSource,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await onTap();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text),
            Image.asset(
              imageSource,
              height: 24,
              width: 24,
            ),
          ],
        ),
      ),
    );
  }
}
