library page_view_360;

import 'package:flutter/material.dart';
import 'package:page_view_360/left_right_slidable.dart';

class ThreeSixtyPageView extends StatefulWidget {
  /// dependencies
  /// required dependencies to using this widget

  /// item builder method
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final EdgeInsets pageMargin;

  const ThreeSixtyPageView({
    Key? key,
    required this.itemBuilder,
    required this.itemCount,
    this.pageMargin = const EdgeInsets.all(0.0),
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
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
          nextChild: widget.itemBuilder(context, index < (widget.itemCount - 1) ? index + 1: index),
          previousChild: widget.itemBuilder(context, index > 0 ? index - 1: index),
          jumpToNextPage: (){
            if(index < (widget.itemCount-1)){
              _pageController.jumpToPage(index+1);
            }
          },
          jumpToPreviousPage: (){
            if(index > 0){
              _pageController.jumpToPage(index-1);
            }
          },
          pagemargin: widget.pageMargin,
        );
      },
    );
  }
}
