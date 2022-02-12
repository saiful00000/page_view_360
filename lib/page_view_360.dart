library page_view_360;

import 'package:flutter/material.dart';
import 'package:page_view_360/left_right_slidable.dart';

class ThreeSixtyPageView extends StatefulWidget {
  /// dependencies
  /// required dependencies to using this widget

  /// item builder method
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final IndexedWidgetBuilder nextItemBuilder;
  final IndexedWidgetBuilder previousItemBuilder;

  const ThreeSixtyPageView({
    Key? key,
    required this.itemBuilder,
    required this.itemCount,
    required this.previousItemBuilder,
    required this.nextItemBuilder,
  }) : super(key: key);

  @override
  _ThreeSixtyPageViewState createState() => _ThreeSixtyPageViewState();
}

class _ThreeSixtyPageViewState extends State<ThreeSixtyPageView> with TickerProviderStateMixin {
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// to right sliding
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.itemCount,
      scrollDirection: Axis.vertical,
      itemBuilder: (ctx, index) {
        return LeftRightSlidAble(
          isFirstItem: index == 0,
          isLastItem: index == (widget.itemCount - 1),
          child: widget.itemBuilder(context, index),
          nextChild: widget.nextItemBuilder(context, index < (widget.itemCount - 1) ? index + 1: index),
          previousChild: widget.previousItemBuilder(context, index > 0 ? index - 1: index),
        );
      },
    );
  }
}
