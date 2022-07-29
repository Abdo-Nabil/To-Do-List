import 'package:flutter/material.dart';

class BuildListTileWithIcon extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onTap;

  const BuildListTileWithIcon({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: ListTile(
        title: Text(text),
        trailing: Icon(
          icon,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
