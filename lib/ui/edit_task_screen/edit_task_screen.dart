import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:to_do_list/models/category_model.dart';
import 'package:to_do_list/models/task_model.dart';
import 'package:to_do_list/logic/cubits/general_cubits/category_cubit/category_cubit.dart';
import 'package:to_do_list/logic/cubits/general_cubits/search_cubit/search_cubit.dart';
import 'package:to_do_list/logic/cubits/general_cubits/date_and_time_cubit/date_and_time_cubit.dart';
import 'package:to_do_list/logic/cubits/screens_cubits/edit_task_cubit/edit_task_cubit.dart';
import 'package:to_do_list/logic/cubits/screens_cubits/home_screen_cubit/home_screen_cubit.dart';
import 'package:to_do_list/services/date_helper.dart';
import 'package:to_do_list/services/db_helper.dart';
import 'package:to_do_list/services/dialog_helper.dart';
import 'package:to_do_list/services/font_helper.dart';
import 'package:to_do_list/services/function_helper.dart';
import 'package:to_do_list/services/notification_helper.dart';
import 'package:to_do_list/services/toast_helper.dart';
import 'package:to_do_list/ui/new_task_screen/build_time_picker.dart';
import 'package:to_do_list/ui/new_task_screen/build_date_picker.dart';
import 'package:to_do_list/ui/new_task_screen/build_drop_down_button.dart';
import 'package:to_do_list/ui/new_task_screen/build_form.dart';
import 'package:to_do_list/ui/new_task_screen/date_rich_text.dart';
import 'package:to_do_list/ui/shared_ui/add_category_button.dart';
import 'package:to_do_list/ui/shared_ui/error_bloc.dart';
import 'package:to_do_list/ui/shared_ui/responsive_sized_box.dart';
import 'package:to_do_list/services/constants.dart';
import 'build_check_box_row.dart';
import 'delete_icon_button.dart';

class EditTaskScreen extends StatefulWidget {
  static const String routeName = 'EditTaskScreen';

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  //these controllers are passed to other widgets and they may be
  // changed there, these changes appears also here and that is exception
  // for TextEditingController

  //Another solution to avoid initialization and declaration here is to
  // use the trick of passing data back...Do you remember..?
  TextEditingController taskTitleController = TextEditingController();
  TextEditingController taskDetailsController = TextEditingController();
  TextEditingController dialogTextController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  //
  final _formKey = GlobalKey<FormState>();
  //
  List<CategoryModel> categoryList = [];
  late String dropDownButtonValue;
  late TaskModel task;

  @override
  Future<void> didChangeDependencies() async {
    print('************** didChangeDependencies called **************');
    task = ModalRoute.of(context)!.settings.arguments as TaskModel;
    await BlocProvider.of<CategoryCubit>(context, listen: false)
        .selectCategory(task.category);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    taskTitleController.dispose();
    taskDetailsController.dispose();
    dialogTextController.dispose();
    timeController.dispose();
    dateController.dispose();
    super.dispose();
  }

  //
  @override
  Widget build(BuildContext context) {
    //
    final searchPreviousState = BlocProvider.of<SearchCubit>(context).state;

    final homeScreenPreviousState =
        BlocProvider.of<HomeScreenCubit>(context, listen: false).state;
    //
    taskTitleController.text = task.title;
    taskDetailsController.text = task.details;
    timeController.text = task.time;
    dateController.text = task.date;
    dropDownButtonValue = task.category;
    //
    return WillPopScope(
      onWillPop: () async {
        final String isChecked =
            BlocProvider.of<EditTaskCubit>(context).isChecked == true
                ? 'true'
                : 'false';
        if (task.title != taskTitleController.text ||
            task.details != taskDetailsController.text ||
            task.date != dateController.text ||
            task.time != timeController.text ||
            task.category != dropDownButtonValue ||
            task.isDone != isChecked) {
          //to hide the key board, try to comment next line and
          // you will see the bug!
          FocusManager.instance.primaryFocus?.unfocus();
          return await DialogHelper.showSaveDialog(context);
        }
        //
        FunctionHelper.refreshHomeScreen(context);
        //
        return true;
      },
      child: GestureDetector(
        //To remove focus from text form fields
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Edit Task'),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                tooltip: 'Share',
                onPressed: () async {
                  await Share.share('• ${task.title}');
                },
              ),
              DeleteIconButton(task),
            ],
          ),
          //
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.done),
            tooltip: 'Confirm',
            onPressed: () async {
              //
              int?
                  notificationId; //it will be null if no date and time selected or if they was in the past date
              //
              final bool isDone =
                  BlocProvider.of<EditTaskCubit>(context).isChecked;
              //
              if (task.title != taskTitleController.text ||
                  task.details != taskDetailsController.text ||
                  task.date != dateController.text ||
                  task.time != timeController.text ||
                  task.category != dropDownButtonValue ||
                  task.isDone != (isDone == true ? 'true' : 'false')) {
                //
                //cancel previous notification if it found
                if (task.notificationId.isNotEmpty) {
                  await NotificationHelper.cancelNotification(
                      task.notificationId);
                }

                //create a new scheduled notification if (isDone = false) and if the new date in future
                final bool isValidDate = DateHelper.combineDateAndTime(
                  date: dateController.text,
                  time: timeController.text,
                  dateParseFormat: k_dateFormat,
                ).isAfter(DateTime.now());
                //
                if (isValidDate && isDone == false) {
                  notificationId = await DBHelper.getNotificationId();
                  await NotificationHelper.createNotification(
                    notificationId: notificationId,
                    title: taskTitleController.text,
                    date: dateController.text,
                    time: timeController.text,
                    payLoad: 'oh',
                  );
                }
                //
                final TaskModel editedTask = TaskModel(
                  id: task.id,
                  notificationId:
                      notificationId == null ? '' : '$notificationId',
                  title: taskTitleController.text,
                  category: dropDownButtonValue,
                  details: taskDetailsController.text,
                  time: timeController.text,
                  date: dateController.text,
                  isDone: '$isDone',
                );
                final bool isValid = FunctionHelper.validateForm(
                  formKey: _formKey,
                );
                if (!isValid) {
                  return;
                }
                await BlocProvider.of<EditTaskCubit>(context)
                    .updateTask(editedTask);

                await FunctionHelper.refreshScreensAfterEditTask(
                    context, homeScreenPreviousState, searchPreviousState);
                //
                ToastHelper.showToast(context, 'Task edited');
              }

              //task not edited
              else {
                ToastHelper.showToast(context, 'Task not edited');
              }

              Navigator.pop(context);
              //
            },
          ),
          //
          body: Scrollbar(
            isAlwaysShown: true,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [
                BuildCheckBoxRow(task),
                // ResponsiveSizedBox(heightRatio: 0.01),
                BuildForm(
                  formKey: _formKey,
                  taskTitleController: taskTitleController,
                  taskDetailsController: taskDetailsController,
                  isFocused: false,
                ),
                ResponsiveSizedBox(heightRatio: 0.03),
                DateRichText(),
                BuildDatePicker(
                  timeController: timeController,
                  dateController: dateController,
                ),
                BlocBuilder<DateAndTimeCubit, DateAndTimeState>(
                  builder: (context, state) {
                    if (state is ShowTimePickerState) {
                      return BuildTimePicker(
                        timeController: timeController,
                        dateController: dateController,
                      );
                    } else if (state is CheckTimePickerState) {
                      if (timeController.text.isEmpty &&
                          dateController.text.isEmpty) {
                        return Container();
                      } else {
                        return BuildTimePicker(
                          timeController: timeController,
                          dateController: dateController,
                        );
                      }
                    }
                    return Container();
                  },
                ),
                ResponsiveSizedBox(heightRatio: 0.03),
                Text(
                  'Category ?',
                  style: FontHelper.subtitle1Bold(context),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Expanded added to add space between the string and the icon
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonHideUnderline(
                          child: BlocBuilder<CategoryCubit, CategoryState>(
                            builder: (context, state) {
                              //
                              if (state is GetCategoriesState) {
                                categoryList = state.categoryList;
                                dropDownButtonValue =
                                    state.dropDownButtonValue; //optional
                                return BuildDropDownButton(
                                  dropdownButtonValue: dropDownButtonValue,
                                  categoryList: categoryList,
                                );
                              }
                              //
                              return ErrorBloc();
                            },
                          ),
                        ),
                      ),
                    ),
                    ResponsiveSizedBox(widthRatio: 0.1),
                    AddCategoryButton(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
