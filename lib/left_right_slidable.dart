import 'dart:developer';

import 'package:flutter/material.dart';

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
    required this.pagemargin,
  }) : super(key: key);

  final Widget child;
  final Widget nextChild;
  final Widget previousChild;
  final bool isLastItem;
  final bool isFirstItem;
  final Function jumpToNextPage;
  final Function jumpToPreviousPage;
  final EdgeInsets pagemargin;

  @override
  _LeftRightSlidAbleState createState() => _LeftRightSlidAbleState();
}

class _LeftRightSlidAbleState extends State<LeftRightSlidAble> with TickerProviderStateMixin {
  /// animation controllers
  late final AnimationController _toLeftAnimationController;
  late final AnimationController _toRightAnimationController;

  /// indicate drag extent value is screen
  double _toLeftDragExtent = 0.0;

  bool showNextWidget = false;
  bool showPreviousWidget = false;

  @override
  void initState() {
    super.initState();
    _toLeftAnimationController = AnimationController(vsync: this);
    _toRightAnimationController = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      /// on start
      onHorizontalDragStart: (DragStartDetails details) {
        setState(() {
          _toLeftDragExtent = 0;
          _toLeftAnimationController.reset();
          _toRightAnimationController.reset();
          showPreviousWidget = false;
          showNextWidget = false;
        });
      },

      /// on update
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        _toLeftDragExtent += details.primaryDelta ?? 0;

        /// if sliding to right
        if (_toLeftDragExtent >= 0) {
          /// if the widget is the first widget then we should block the sliding
          if (widget.isFirstItem) return;
          setState(() {
            showNextWidget = false;
            showPreviousWidget = true;
            _toRightAnimationController.value = _toLeftDragExtent / (context.size?.width ?? 1.0);
          });
          return;
        }


        /// if the widget is last one then stop
        if (widget.isLastItem) return;
        /// if sliding to left
        /// calculate how much we dragged into the screen
        setState(() {
          showPreviousWidget = false;
          showNextWidget = true;
          _toLeftAnimationController.value = _toLeftDragExtent.abs() / (context.size?.width ?? 1.0);
        });
      },

      /// on end
      onHorizontalDragEnd: (DragEndDetails details) async {
        /// if slided bellow 10% of screen
        /// then reverse the animation
        // if (_toLeftAnimationController.value < 0.1) {
        //   _toLeftAnimationController.fling(velocity: -1);
        // } else {
        //   /// slide to right
        //   await _toLeftAnimationController.fling();
        //   widget.jumpToPreviousPage();
        // }
        /// if slided to left
        print('to left controller value = ${_toLeftAnimationController.value}');
        if(_toLeftAnimationController.value > 0.0){
          await _toLeftAnimationController.fling();
          widget.jumpToNextPage();
        }


        // if (_toRightAnimationController.value > 0.1) {
        //   _toRightAnimationController.fling();
        // } else {
        //   await _toRightAnimationController.fling(velocity: -1);
        //   widget.jumpToNextPage();
        // }
        /// is slide to right
        print('to right controller value = ${_toRightAnimationController.value}');
        if(_toRightAnimationController.value > 0.0){
            await _toRightAnimationController.fling();
            widget.jumpToPreviousPage();
        }
      },

      /// child widget
      child: Stack(
        children: [


          /// next widget
          Visibility(
            visible: showNextWidget,
            child: Container(
              child: widget.nextChild,
            ),
          ),


          /// previous Widget
          Visibility(
            visible: showPreviousWidget,
            child: Container(
              child: widget.previousChild,
            ),
          ),


          /// primary widget
          AnimatedBuilder(
            animation: _toRightAnimationController,
            builder: (context, child) {
              return SlideTransition(
                position: AlwaysStoppedAnimation(Offset(_toRightAnimationController.value, 0.0)),

                /// to left sliding
                child: AnimatedBuilder(
                  animation: _toLeftAnimationController,
                  builder: (context, child) {
                    return SlideTransition(
                      position: AlwaysStoppedAnimation(Offset(-_toLeftAnimationController.value, 0.0)),
                      child: Padding(
                        padding: widget.pagemargin,
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
