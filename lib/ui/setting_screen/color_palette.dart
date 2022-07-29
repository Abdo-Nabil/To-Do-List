import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:to_do_list/logic/cubits/setting_cubits/color_palette_cubit/color_palette_cubit.dart';
import 'package:to_do_list/services/my_themes.dart';
import 'package:to_do_list/ui/shared_ui/error_bloc.dart';
import 'package:to_do_list/services/constants.dart';

class ColorPalette extends StatefulWidget {
  @override
  _ColorPaletteState createState() => _ColorPaletteState();
}

class _ColorPaletteState extends State<ColorPalette> {
  @override
  void initState() {
    BlocProvider.of<ColorPaletteCubit>(context).getColor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //
    return BlocBuilder<ColorPaletteCubit, ColorPaletteState>(
      builder: (context, state) {
        //
        if (state is GetColorPaletteState) {
          return ListTile(
            title: Text('Picked color'),
            subtitle: Text(state.colorName),
            onTap: () async {
              await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Pick a color !'),
                    // title: Text.rich(
                    //   TextSpan(
                    //     text: 'Pick a color !\n',
                    //     children: <TextSpan>[
                    //       TextSpan(
                    //         text: '"Colors only work on light mode"',
                    //         style: TextStyle(
                    //           fontSize:
                    //               FontHelper.bodyText2Default(context).fontSize,
                    //           fontWeight: FontWeight.normal,
                    //           height: 2.6,
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    //   child: Text('"Colors only work on light mode"'),
                    // ),
                    content: Scrollbar(
                      isAlwaysShown: true,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: BlockPicker(
                          availableColors: MyThemes.colorsList,
                          pickerColor: Color(state.colorValue),
                          onColorChanged: (Color color) async {
                            await BlocProvider.of<ColorPaletteCubit>(context)
                                .selectColor(color.value);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Text('Reset default color'),
                        onPressed: () async {
                          await BlocProvider.of<ColorPaletteCubit>(context)
                              .selectColor(appDefaultColor.value);
                          Navigator.pop(context);
                        },
                      ),
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
