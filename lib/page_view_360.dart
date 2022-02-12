library page_view_360;

import 'package:flutter/material.dart';
import 'package:page_view_360/left_right_slidable.dart';

class ThreeSixtyPageView extends StatefulWidget {
  /// dependencies
  /// required dependencies to using this widget

  /// item builder method
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;

  const ThreeSixtyPageView({Key? key, required this.itemBuilder, required this.itemCount}) : super(key: key);

  @override
  _ThreeSixtyPageViewState createState() => _ThreeSixtyPageViewState();
}

class _ThreeSixtyPageViewState extends State<ThreeSixtyPageView> with TickerProviderStateMixin {


  @override
  Widget build(BuildContext context) {
    /// to right sliding
    return PageView.builder(
      itemCount: widget.itemCount,
      scrollDirection: Axis.vertical,
      itemBuilder: (ctx, index) {
        return LeftRightSlidAble(
          child: widget.itemBuilder(context, index),
        );
      },
    );
  }
}
