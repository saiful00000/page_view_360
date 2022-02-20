import 'package:flutter/material.dart';
import 'package:page_view_360/page_view_360.dart';

/// A slide-able widget build using [AnimatedBuilder] and [SlideTransition]
class LeftRightSlidAble extends StatefulWidget {
  const LeftRightSlidAble({
    Key? key,
    required this.child,
    required this.previousChild,
    required this.nextChild,
    required this.isLastItem,
    required this.isFirstItem,
    required this.jumpToPreviousPage,
    required this.jumpToNextPage,
    required this.pageMargin,
  }) : super(key: key);

  /// The current page widget that is visible in screen
  final Widget child;

  /// The next widget that will appear after slide to left
  ///
  /// represent the next page
  final Widget nextChild;

  /// The previous widget that will appear after slide to right
  ///
  /// represent the previous page
  final Widget previousChild;

  /// true if current page is the last page
  final bool isLastItem;

  /// true if current page is the first page
  final bool isFirstItem;

  /// This callback is the trick here, its help to update current page by jumping
  /// to required page.
  ///
  /// its execute after sliding to left animation complete to update the
  /// [ThreeSixtyPageView] current page
  final Function jumpToNextPage;

  /// This callback is the trick here, its help to update current page by jumping
  /// to required page.
  ///
  /// its execute after sliding to right animation complete to update the
  /// [ThreeSixtyPageView] current page
  final Function jumpToPreviousPage;
  final EdgeInsets pageMargin;

  @override
  _LeftRightSlidAbleState createState() => _LeftRightSlidAbleState();
}

class _LeftRightSlidAbleState extends State<LeftRightSlidAble>
    with TickerProviderStateMixin {
  /// animation controllers
  late final AnimationController _toLeftAnimationController;
  late final AnimationController _nextAnimationController;
  late final AnimationController _toRightAnimationController;
  late final AnimationController _previousAnimationController;

  /// indicate drag extent value is screen
  double _toLeftDragExtent = 0.0;

  /// A flag to detect whether next next should visible or not
  ///
  /// default is true
  bool showNextWidget = false;

  /// A flag to detect whether next page should be visible or not
  bool showPreviousWidget = false;

  @override
  void initState() {
    super.initState();
    _toLeftAnimationController = AnimationController(vsync: this);
    _nextAnimationController = AnimationController(vsync: this);
    _toRightAnimationController = AnimationController(vsync: this);
    _previousAnimationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _toLeftAnimationController.dispose();
    _nextAnimationController.dispose();
    _toRightAnimationController.dispose();
    _previousAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      /// on start
      onHorizontalDragStart: (DragStartDetails details) {
        setState(() {
          _toLeftDragExtent = 0;
          _toLeftAnimationController.reset();
          _nextAnimationController.reset();
          _toRightAnimationController.reset();
          _previousAnimationController.reset();
          showPreviousWidget = false;
          showNextWidget = false;
        });
      },

      /// on update
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        _toLeftDragExtent += details.primaryDelta ?? 0;

        // if sliding to right
        if (_toLeftDragExtent >= 0) {
          // if the widget is the first widget then we should block the sliding
          if (widget.isFirstItem) return;
          setState(() {
            showNextWidget = false;
            showPreviousWidget = true;
            _toRightAnimationController.value =
                _toLeftDragExtent / (context.size?.width ?? 1.0);
            _previousAnimationController.value =
                _toLeftDragExtent / (context.size?.width ?? 1.0);
          });
          return;
        }

        // if the widget is last one then stop
        if (widget.isLastItem) return;

        // if sliding to left
        /// calculate how much we dragged into the screen
        setState(() {
          showPreviousWidget = false;
          showNextWidget = true;
          _toLeftAnimationController.value =
              _toLeftDragExtent.abs() / (context.size?.width ?? 1.0);
          _nextAnimationController.value =
              _toLeftDragExtent.abs() / (context.size?.width ?? 1.0);
        });
      },

      /// on end
      onHorizontalDragEnd: (DragEndDetails details) async {
        /// if slided bellow 10% of screen
        /// then reverse the animation
        // if slided to left
        //print('to left controller value = ${_toLeftAnimationController.value}');
        if (_toLeftAnimationController.value > 0.2) {
          _toLeftAnimationController.fling();
          await _nextAnimationController.fling();
          widget.jumpToNextPage();
        } else {
          // if dragged less than 20% to left then back to previous sate
          _toLeftAnimationController.fling(velocity: -1);
          _nextAnimationController.fling(velocity: -1);
        }

        // is slide to right
        //print('to right controller value = ${_toRightAnimationController.value}');
        if (_toRightAnimationController.value > 0.2) {
          _toRightAnimationController.fling();
          await _previousAnimationController.fling();
          widget.jumpToPreviousPage();
        } else {
          // if dragged les than 20% to right then back to previous state
          _toRightAnimationController.fling(velocity: -1);
          _previousAnimationController.fling(velocity: -1);
        }
      },

      /// child widget
      child: Stack(
        children: [
          /// next widget
          Visibility(
            visible: showNextWidget,
            child: AnimatedBuilder(
              animation: _nextAnimationController,
              builder: (context, child) {
                return SlideTransition(
                  position: AlwaysStoppedAnimation(
                      Offset((-_nextAnimationController.value + 1), 0.0)),
                  child: widget.nextChild,
                );
              },
            ),
          ),

          /// previous Widget
          Visibility(
            visible: showPreviousWidget,
            child: AnimatedBuilder(
              animation: _previousAnimationController,
              builder: (context, child) {
                return SlideTransition(
                  position: AlwaysStoppedAnimation(
                      Offset(_previousAnimationController.value - 1, 0.0)),
                  child: widget.previousChild,
                );
              },
            ),
          ),

          /// primary widget
          AnimatedBuilder(
            animation: _toRightAnimationController,
            builder: (context, child) {
              return SlideTransition(
                position: AlwaysStoppedAnimation(
                    Offset(_toRightAnimationController.value, 0.0)),

                /// to left sliding
                child: AnimatedBuilder(
                  animation: _toLeftAnimationController,
                  builder: (context, child) {
                    return SlideTransition(
                      position: AlwaysStoppedAnimation(
                          Offset(-_toLeftAnimationController.value, 0.0)),
                      child: Padding(
                        padding: widget.pageMargin,
                        child: widget.child,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
