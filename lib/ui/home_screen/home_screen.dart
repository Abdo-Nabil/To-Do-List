import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/models/category_model.dart';
import 'package:to_do_list/logic/cubits/general_cubits/category_cubit/category_cubit.dart';
import 'package:to_do_list/logic/cubits/general_cubits/selection_cubit/selection_cubit.dart';
import 'package:to_do_list/logic/cubits/general_cubits/date_and_time_cubit/date_and_time_cubit.dart';
import 'package:to_do_list/logic/cubits/screens_cubits/home_screen_cubit/home_screen_cubit.dart';
import 'package:to_do_list/services/function_helper.dart';
import 'package:to_do_list/services/toast_helper.dart';
import 'package:to_do_list/ui/home_screen/search_icon_button.dart';
import 'package:to_do_list/ui/home_screen/side_drawer.dart';
import 'package:to_do_list/ui/new_task_screen/new_task_screen.dart';
import 'package:to_do_list/ui/shared_ui/center_progress_indicator.dart';
import 'package:to_do_list/ui/shared_ui/error_bloc.dart';
import 'package:to_do_list/ui/shared_ui/get_app_bar.dart';
import 'app_bar_title.dart';
import 'build_list_view.dart';
import '../shared_ui/no_tasks_widget.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'HomeScreen';
  final bool isPopped;

  //the general case that HomeScreen is just popped from other screens
  // and being emitted already from previous screen to get home screen state
  // a few cases will be navigated
  const HomeScreen({
    this.isPopped = true,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    //initialize Toasts package
    ToastHelper.initializeToast(context);
    //

    if (widget.isPopped == false) {
      //Do nothing, just return to Home screen with the same state,
    }
    //
    else {
      BlocProvider.of<HomeScreenCubit>(context, listen: false)
          .getStartupTasksAndCategory();
    }
    print('********************* initState ************************');
    super.initState();
  }

//ToDo: remove focus in all text fields by pressing back button 'by closing the keyboard'
  //
  Future<void> addTaskOnPressed() async {
    await BlocProvider.of<SelectionCubit>(context).disableSelectionMode();
    //
    //In newTaskScreen select category as same as the category in appBar of HomeScreen !
    final HomeScreenState homeScreenState =
        BlocProvider.of<HomeScreenCubit>(context).state;

    if (homeScreenState is GetAllCategoriesTasksState) {
      //this check because we have not a category in database called 'All Categories'
      await BlocProvider.of<CategoryCubit>(context)
          .selectCategory(CategoryModel.getDefaultCategory);
    } else {
      await BlocProvider.of<CategoryCubit>(context)
          .selectCategory(homeScreenState.props[1].toString());
    }
    //to hide time picker if it was used in adding the previous task
    BlocProvider.of<DateAndTimeCubit>(context).emit(DateAndTimeInitialState());
    //
    await Navigator.pushNamed(context, NewTaskScreen.routeName);
  }

  Widget build(BuildContext context) {
    print('********************* built home *********************************');
    //triggered when backButton pressed (physical button or appBar default button)
    return WillPopScope(
      onWillPop: () async {
        final bool isToGoBAck = FunctionHelper.isToGoBack(context);

        if (isToGoBAck == false) {
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: GetAppBar(
          defaultAppBar: AppBar(
            actions: [
              SearchIconButton(),
            ],
            title: AppBarTitle(), //the dropDownButton
          ),
          isHomeScreenSelectionAppBar: true,
          isCompletedTasksScreenSelectionAppBar: false,
          isSearchScreenSelectionAppBar: false,
        ),
        drawer: SideDrawer(
          //just to be used in MediaQuery
          AppBar(),
        ),
        //
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add task',
          child: const Icon(Icons.add),
          onPressed: () async {
            await addTaskOnPressed();
          },
        ),
        //
        body: BlocBuilder<HomeScreenCubit, HomeScreenState>(
          builder: (context, state) {
            if (state is HomeScreenLoadingState) {
              return CenterProgressIndicator();
            }
            //
            else if (state is GetAllCategoriesTasksState) {
              final orderedTasks =
                  FunctionHelper.generateOrderedTasks(state.tasks);
              return orderedTasks.length > 0
                  ? BuildListView(
                      orderedTasks,
                    )
                  : NoTasksWidget(
                      greyText: 'No tasks in ',
                      boldText: 'All categories',
                      showImage: true,
                    );
            }
            //
            else if (state is GetSelectedCategoryTasksState) {
              final orderedTasks =
                  FunctionHelper.generateOrderedTasks(state.tasks);
              return orderedTasks.length > 0
                  ? BuildListView(orderedTasks)
                  : NoTasksWidget(
                      greyText: 'No tasks in ',
                      boldText: state.categoryName,
                      showImage: true,
                    );
            }
            return ErrorBloc();
          },
        ),
      ),
    );
  }
}
