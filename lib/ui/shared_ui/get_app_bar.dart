import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/logic/cubits/general_cubits/selection_cubit/selection_cubit.dart';
import 'package:to_do_list/ui/shared_ui/selection_app_bar.dart';

class GetAppBar extends StatelessWidget implements PreferredSizeWidget {
  final defaultAppBar;
  final bool isHomeScreenSelectionAppBar;
  final bool isCompletedTasksScreenSelectionAppBar;
  final bool isSearchScreenSelectionAppBar;

  const GetAppBar({
    required this.defaultAppBar,
    required this.isHomeScreenSelectionAppBar,
    required this.isCompletedTasksScreenSelectionAppBar,
    required this.isSearchScreenSelectionAppBar,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectionCubit, SelectionState>(
      builder: (context, state) {
        //
        if (state is EnableSelectionModeState) {
          return SelectionAppBar(
            isHomeScreenSelectionAppBar: isHomeScreenSelectionAppBar,
            isCompletedTasksScreenSelectionAppBar:
                isCompletedTasksScreenSelectionAppBar,
            isSearchScreenSelectionAppBar: isSearchScreenSelectionAppBar,
          );
        }
        return defaultAppBar;
      },
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
