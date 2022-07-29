import 'package:flutter/material.dart';
import 'package:to_do_list/services/font_helper.dart';
import 'package:to_do_list/ui/shared_ui/responsive_sized_box.dart';
import 'package:to_do_list/services/constants.dart';

class NoTasksWidget extends StatefulWidget {
  final String greyText;
  final String boldText;
  final bool showImage;

  const NoTasksWidget({
    required this.greyText,
    required this.boldText,
    required this.showImage,
  });

  @override
  _NoTasksWidgetState createState() => _NoTasksWidgetState();
}

class _NoTasksWidgetState extends State<NoTasksWidget>
    with TickerProviderStateMixin {
  //
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration:
        const Duration(milliseconds: k_no_tasks_widget_animation_duration),
  );
  //
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return FadeTransition(
      opacity: _animation,
      //ToDo: note :All this complex logic is just for centering the widgets in list view!
      child: LayoutBuilder(builder: (context, constraints) {
        return ListView(
          children: [
            Container(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.showImage
                      ? Image.asset(
                          'lib/assets/images/relax.png',
                        )
                      : Container(),
                  ResponsiveSizedBox(
                    heightRatio: 0.025,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text.rich(
                      TextSpan(
                        text: widget.greyText,
                        style: TextStyle(
                          fontSize: FontHelper.headline6(context).fontSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: widget.boldText,
                            style: TextStyle(
                              fontSize: FontHelper.headline6(context).fontSize,
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
