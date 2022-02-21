library page_view_360;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_view_360/left_right_slidable.dart';

class ThreeSixtyPageView extends StatefulWidget {
  /// create a scrollable list that scroll page by page in both direction
  /// [vertically] and [horizontally] at the same time.

  /// provide a [PageView.builder] with ability to slide in 4 direction
  /// using the [itemBuilder] Callback
  ///
  /// The [itemCount], [itemBuilder] must not be null.
  const ThreeSixtyPageView({
    Key? key,
    this.pageController,
    required this.itemBuilder,
    required this.itemCount,
    this.pageMargin = const EdgeInsets.all(0.0),
    this.onPageChanged,
  }) : super(key: key);

  /// A callback method to performs that call when a page changed
  /// and provide the current page [page] an parameter
  final Function(int page)? onPageChanged;

  /// A controller that control the [ThreeSixtyPageView] and provide basic
  /// functionality to jump or animate to various pages
  final PageController? pageController;

  /// A delegate that provide page widgets for [ThreeSixtyPageView]
  final IndexedWidgetBuilder itemBuilder;

  /// The total number of widget this [ThreeSixtyPageView] will provide
  /// And the value of [itemCount] is never be negative
  ///
  /// Default is 0
  final int itemCount;

  /// The margin around the page
  final EdgeInsets pageMargin;

  @override
  _ThreeSixtyPageViewState createState() => _ThreeSixtyPageViewState();
}

class _ThreeSixtyPageViewState extends State<ThreeSixtyPageView>
    with TickerProviderStateMixin {
  late final PageController _pageController;

  @override
  void initState() {
    _pageController = widget.pageController ?? PageController();
    super.initState();
  }

  @override
  void dispose() {
    widget.pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// to right sliding
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.itemCount < 0 ? 0 : widget.itemCount,
      scrollDirection: Axis.vertical,
      onPageChanged: widget.onPageChanged,
      itemBuilder: (ctx, index) {
        return LeftRightSlidAble(
          isFirstItem: index == 0,
          isLastItem: index == (widget.itemCount - 1),
          child: widget.itemBuilder(context, index),
          nextChild: widget.itemBuilder(
              context, index < (widget.itemCount - 1) ? index + 1 : index),
          previousChild:
              widget.itemBuilder(context, index > 0 ? index - 1 : index),
          jumpToNextPage: () {
            if (index < (widget.itemCount - 1)) {
              _pageController.jumpToPage(index + 1);
            }
          },
          jumpToPreviousPage: () {
            if (index > 0) {
              _pageController.jumpToPage(index - 1);
            }
          },
          pageMargin: widget.pageMargin,
        );
      },
    );
  }
}
