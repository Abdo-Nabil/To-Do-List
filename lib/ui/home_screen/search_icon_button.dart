import 'package:flutter/material.dart';
import 'package:to_do_list/ui/search_screen/search_screen.dart';
import 'package:to_do_list/services/custom_page_route.dart';

class SearchIconButton extends StatelessWidget {
  //
  @override
  Widget build(BuildContext context) {
    //
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: IconButton(
        icon: const Icon(Icons.search),
        tooltip: 'Search',
        onPressed: () {
          Navigator.of(context).push(
            CustomPageRoute(
              builder: (BuildContext context) {
                return SearchScreen();
              },
            ),
          );
        },
      ),
    );
  }
}
