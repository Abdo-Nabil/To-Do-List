import 'package:flutter/material.dart';
import 'package:to_do_list/services/font_helper.dart';

class BuildSideDrawerItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onTap;

  const BuildSideDrawerItem({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        text,
        style: FontHelper.subtitle1Default(context),
      ),
      leading: Icon(
        icon,
        color: Theme.of(context).iconTheme.color,
      ),
      onTap: () async {
        await onTap();
      },
    );
  }
}
