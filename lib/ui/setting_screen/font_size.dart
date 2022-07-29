import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/logic/cubits/setting_cubits/font_size_cubit/font_size_cubit.dart';
import 'package:to_do_list/services/function_helper.dart';
import 'package:to_do_list/ui/shared_ui/error_bloc.dart';

class FontSize extends StatefulWidget {
  const FontSize({Key? key}) : super(key: key);

  @override
  _FontSizeState createState() => _FontSizeState();
}

class _FontSizeState extends State<FontSize> {
  @override
  void initState() {
    BlocProvider.of<FontSizeCubit>(context).getFontSize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FontSizeCubit, FontSizeState>(
      builder: (context, state) {
        if (state is GetFontSizeState) {
          return ListTile(
            title: Text('Font size'),
            subtitle: Text(state.fontSize),
            onTap: () async {
              await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Font size'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...List.generate(
                          3,
                          (index) {
                            return RadioListTile(
                              //selected: false,
                              //selectedTileColor: Colors.grey,
                              title: Text(FunctionHelper.fontSizeList[index]),
                              contentPadding: EdgeInsets.zero,
                              value: FunctionHelper.fontSizeList[index],
                              groupValue: state.fontSize,
                              //
                              onChanged: (value) async {
                                await BlocProvider.of<FontSizeCubit>(context)
                                    .selectFontSize(value as String);
                                Navigator.pop(context);
                              },
                              //
                            );
                          },
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                },
              );
            },
          );
        }
        return ErrorBloc();
      },
    );
  }
}
