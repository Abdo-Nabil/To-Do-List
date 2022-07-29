import 'package:flutter/material.dart';

class BuildSideDrawerDivider extends StatelessWidget {
  const BuildSideDrawerDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 1,
      color: Theme.of(context).primaryColorLight,
    );
  }
}
